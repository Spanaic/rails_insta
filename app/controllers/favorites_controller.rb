class FavoritesController < ApplicationController
    # def create
    #     # favorite = current_user.favorites.new
    #     favorite = Favorite.new
    #     favorite.user_id = current_user.id
    #     favorite.post_image_id = (params[:post_image_id])
    #     favorite.save
    #     redirect_to post_image_path(params[:post_image_id])
    # end

    # def destroy
    #     favorite = Favorite.find(params[:id])
    #     favorite.destroy
    #     @post_image = (params[:id])
    #     redirect_to post_image_path(params[:post_image_id])
    # end

    def create
        post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.new(post_image_id: post_image.id)
        favorite.save
        redirect_to post_image_path(post_image.id)
        # render :show
    end

    def destroy
        post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.find_by(post_image_id: post_image.id)
        # 現在ログインしているユーザに関連したデータをアソシエーションされたfavoritesモデルから探してきてね。
        # 見つけてきた情報　＝＞current_user情報、そのユーザのfavorites情報（favoritesモデルのpost_image_idと同じものを,post_imageモデルのidからfindする）
        # favorited_byメソッドを使用することによってuser_idとpost_image_idが紐づくのではないか・・・
        favorite.destroy
        redirect_to post_image_path(post_image.id)
        # render :show
    end
end
