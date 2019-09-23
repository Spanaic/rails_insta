class UsersController < ApplicationController
    def index
        @users = User.page(params[:page]).per(20)
    end

    def show
        @user = User.find(params[:id])
        @post_images = @user.post_images.all
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        @user.name = current_user.name
        if @user.update(user_params)
            redirect_to user_path(@user.id)
        else
            render :edit
        end
    end

    def follows
        @user = User.find(params[:id])
        @follows = @user.followings.all
    end
    # ＠userにフォローされている人を集めたページ
    # followingsはUserモデルで定義した擬似クラス
    # through:activeに＠userから受け取った外部キーを入れて、アソシエーションされたfollowerをすべて取得する。

    def followers
        @user = User.find(params[:id])
        @followers = @user.followers.all
    end

    # 上の逆。

    private
    def user_params
        params.require(:user).permit(:profile_image, :profile_name, :introduction)
    end
end
