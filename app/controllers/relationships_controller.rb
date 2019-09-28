class RelationshipsController < ApplicationController
    def create
        @user = User.find_by(profile_name: params[:user_profile_name])
        # binding.pry
        follow = current_user.active_relationships.build(following_id: current_user.id, follower_id: @user.id)
        # buildはアソシエーションされたモデルに外部キーを渡すようなレコードを作成する時に用いられるメソッド
        # .newとの違いは現行のrailsには存在しないが、関連付けのモデルに生成していることがわかるように使い分けられている会社もある
        follow.save
        @user.create_notification_follow(current_user)
        redirect_to user_path(params[:user_profile_name])
    end
    # アソシエーションで受け取るプライマリーキーはid:integer型じゃないとだめかもしれない（たとえロジック上変数や引数が渡ってたとしても）

    def destroy
        @user = User.find_by(profile_name: params[:user_profile_name])
        follow = current_user.active_relationships.find_by(follower_id: @user.id)
        follow.destroy
        redirect_to user_path(params[:user_profile_name])
    end
end
