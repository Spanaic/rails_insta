class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!, except: [:index]

    def after_sign_out_path_for(resource)
        new_user_session_path
        # new_user_session_path(resource)引数を足すとURL'.'userが表示されてしまう。
        # 余計なIDを渡した時にバグるやつ
    end

    def after_sign_in_path_for(resource)
        root_path
    end
    # after_sign_out_path_for(resource)はメソッドとしてアプリケーションコントローラ内にきちんと定義する
    def after_sign_up_path_for(resource)
        root_path
    end

    protected
        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile_name])
            devise_parameter_sanitizer.permit(:sign_in, keys: [:profile_name])
        end
end
