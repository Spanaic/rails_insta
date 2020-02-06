class EndUsersController < ApplicationController
    protect_from_forgery :except => [:create, :update]


    def index
        user = EndUser.find_by(email: params[:email])
        users = EndUser.all

        end_users = []
        end_users.push(user)
        end_users.push(users)

        render :json => end_users
    end

    def show
        @user = EndUser.find(params[:id]).to_json(include: [:favorites, :post_images, :post_comments, :active_relationships, :passive_relationships, :followings, :followers, :active_notifications, :passive_notifications])
        p @user
        render :json => @user
    end

    def new

    end

    def create
        user = EndUser.new(end_user_params)
        if user.save!
        else
        puts user.errors.full_messages
        end
        render :json => user
    end

    def destroy

    end

    def edit
        @user = EndUser.find(params[:id])
        render :json => @user
    end

    def update
        uploaded_file =  params[:end_user][:image]
        file_name = params[:end_user][:profile_image_name]
        output_path = Rails.root.join('public/end_users', file_name)

        File.open(output_path, 'w+b') do |fp|
            fp.write  uploaded_file.read
        end

        end_user = EndUser.find(params[:id])

        if end_user.update!(end_user_params)
            render :json => end_user
        else
            puts end_user.errors.full_messages
            render :json => end_user
        end
    end

    def follows
        @user = EndUser.find(params[:id])
        @follows = @user.followings.all
        follows = @follows.to_json(include: [:favorites, :post_images, :post_comments, :active_relationships, :passive_relationships, :followers, :active_notifications, :passive_notifications])
        render :json => follows
    end

    def followers
        @user = EndUser.find(params[:id])
        @followers = @user.followers.all
        followers = @followers.to_json(include: [:favorites, :post_images, :post_comments, :active_relationships, :passive_relationships, :followings, :active_notifications, :passive_notifications])
        render :json => followers
    end

    def explore

    end

    private
    def end_user_params
        params.require(:end_user).permit(:email, :name, :profile_name, :profile_image_name)
    end
end
