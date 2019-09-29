class UsersController < ApplicationController
    def index
        @users = User.page(params[:page]).per(20).reverse_order
        # 試しに入れてる記述↓↓↓
        # @post_images = @users.post_images.id.last
        # @notifications = Notification.all
        @randoms = User.order("RAND()").limit(2)
    end

    def show
        @user = User.find_by(profile_name: params[:profile_name])
        # params[:id]などの該当する記述（User）を[:name]に書き換える。
        # @reply_user = User.find_by(profile_name: params[:profile_name])
        @post_images = @user.post_images.page(params[:page]).per(9).reverse_order
        # 元々allで変数に代入していたので、kaminari風に変数に値を代入してあげれば、指定した数の表示件数にになる。
    end

    def edit
        @user = User.find_by(profile_name: params[:profile_name])
        # .findメソッドはID検索。id以外をキーにレコードを引っ張る時は.find_byメソッドを使う。
    end

    def update
        @user = User.find_by(profile_name: params[:profile_name])
        @user = current_user
        if @user.update(user_params)
            redirect_to user_path(@user.profile_name)
        else
            render :edit
        end
    end

    def follows
        @user = User.find_by(profile_name: params[:profile_name])
        @follows = @user.followings.all
    end
    # ＠userにフォローされている人を集めたページ
    # followingsはUserモデルで定義した擬似クラス
    # through:activeに＠userから受け取った外部キーを入れて、アソシエーションされたfollowerをすべて取得する。

    def followers
        @user = User.find_by(profile_name: params[:profile_name])
        @followers = @user.followers.all
    end

    # 上の逆。

    def reply_user
        @user = User.find_by(profile_name: params[:profile_name])
        # (params[:id])で渡していた部分でエラーが出る可能性有り
        redirect_to user_path(params[:profile_name])
    end

    private
    def user_params
        params.require(:user).permit(:profile_image, :profile_name, :introduction)
    end
end
