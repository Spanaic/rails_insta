class FavoritesController < ApplicationController
    def create
        # favorite = current_user.favorites.new
        favorite = Favorite.new
        favorite.user_id = current_user.id
        favorite.post_image_id = (params[:post_image_id])
        favorite.save
        redirect_to post_image_path(params[:post_image_id])
    end

    def destroy
        favorite = Favorite.find(params[:id])
        favorite.destroy
        @post_image = (params[:id])
        redirect_to post_image_path(params[:post_image_id])
    end
end
