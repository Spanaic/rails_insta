class RelationshipsController < ApplicationController
    def create
        follow = current_user.active_relationships.build(follower_id: params[:user_id])
        # buildはアソシエーションされたモデルに外部キーを渡すようなレコードを作成する時に用いられるメソッド
        # .newとの違いは現行のrailsには存在しないが、関連付けのモデルに生成していることがわかるように使い分けられている会社もある
        follow.save
binding.pry
        follow.create_notification_follow(current_user)

        redirect_to user_path(params[:user_id])
    end

    def destroy
        follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
        follow.destroy
        redirect_to user_path(params[:user_id])
    end
end
