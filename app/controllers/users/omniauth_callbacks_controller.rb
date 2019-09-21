class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # メンターさんより
    # gitにomniauthジェムによるSNS認証の方法がしっかりと記述されている
    # コントローラの名前の書き方は、classの継承が行われている。
    # controllers内のディレクトリ::コントローラ名　<右のコントローラの内容を継承します< Deviseコントローラは見えてないけど存在する::OmniauthCallbacksControllerもその一つ
    # 左のコントローラ内にアクションを記述していくことで、右のコントローラへと書き足しているのと同義になる。
    # Deviseのコントローラは継承という形で視える化することが可能。継承なので機能の上書きや、書き足しなどのカスタマイズもできるが、ここのユーザのアクションを変更してしまう可能性があるためセキュリティ的に微妙かも…

    # class OmniauthCallbacksController < ApplicationController
    # 上記の記述ではアプリケーションコントローラを継承しているため、deviseのコントローラとしての機能を継承できていない
    def facebook
        callback_from :facebook
    end

    private

    def callback_from(provider)
        provider = provider.to_s

        @user = User.find_for_oauth(request.env['omniauth.auth'])

        if @user.persisted?
            flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
            sign_in_and_redirect @user, event:  :authentication
        else
            session["devise.#{provider}_data"] = request.env['omniauth.auth']
            redirect_to new_user_registration_url
        end
    end
end
