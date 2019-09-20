class UsersController < ApplicationController
    def index
        @users = User.all
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

    private
    def user_params
        params.require(:user).permit(:profile_image, :profile_name, :introduction)
    end
end
