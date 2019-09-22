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
    # showページにfavoriteのidパラメータが存在しないため（URL参照）、findメソッドのparams[:id]にパラメータを渡す事ができない。別の方法でパラメータを取得する必要がある。
    #     favorite.destroy
    #     @post_image = (params[:id])
    #     redirect_to post_image_path(params[:post_image_id])
    # end

    def create
        post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.new(post_image_id: post_image.id)

        # メンターさんの教え
        # current_userのfavoritesモデルから（このカラム名の中から: 指定した変数.該当するID）を代入したレコードをnewしてね！という記述

        # current_userでuser_idを埋めて、変数post_imageで取得したpost_image.idをfavoritesモデルのpost_image_idから引っ張ってくる。
        # 変数favoriteにuser_idとpost_image_idの2つが一気に代入される。
        # カラムが埋まるので、データを保存できるようになる。
        favorite.save
        redirect_to post_image_path(post_image.id)

        下の記述ではmissing templateのエラーでうまく条件分岐されない。
        # @post_comment = PostComment.new
        # @favorite = Favorite.new
        # if render :show
        # else
        #     @post_images = PostImage.all
        #     render :index
        # end
        # レンダーだとなぜ非同期通信のよう
    end

    def destroy
        post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.find_by(post_image_id: post_image.id)

        # current_userのfavoritesモデルから（このカラム名の中から: 指定した変数.該当するID）を探してきてね！という記述。
        # find_byメソッドは（探したいカラム名: 該当のID等）などの条件を指定して探してくるメソッド。
        # findメソッドはパラメータに渡るIDを探してくるメソッド


        # 現在ログインしているユーザに関連したデータをアソシエーションされたfavoritesモデルから探してきてね。
        # 見つけてきた情報　＝＞current_user情報、そのユーザのfavorites情報（favoritesモデルのpost_image_idと同じものを,post_imageモデルのidからfindする）
        # favorited_byメソッドを使用することによってuser_idとpost_image_idが紐づくのではないか・・・
        favorite.destroy
        redirect_to post_image_path(post_image.id)
        # render :show
    end
end
