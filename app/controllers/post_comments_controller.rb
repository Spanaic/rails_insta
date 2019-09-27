class PostCommentsController < ApplicationController
    def create
        @post_image = PostImage.find(params[:post_image_id])
        post_comment = PostComment.new(post_comment_params)
        post_comment.post_image_id = @post_image.id
        post_comment.user_id = current_user.id
        # create,destroy,updateなどアクションメソッド内で完結する場合（Viewに変数を渡さない場合）はローカル変数を使っておくほうがセキュリティ上良い。
        if  post_comment.save

            post_comment.create_notification_post_comment(current_user, post_comment.id)

            redirect_to post_image_path(params[:post_image_id])
        else
            render template: "post_images/show"
            # ネストされたコントローラのレンダー先は一体どこに？
            # template:オプションから、"コントローラ/アクション"で呼び出しを行う
            # 上記はviewも呼び出す場合
            # if内、renderの前に変数を定義することで、どのタイミングで使われる変数かわかりやすく記述することができる。
        # else
        #     render template: "users/show"
        #     # ここは動作確認をしてみる必要あり
        end
    end

    def destroy
        # @post_image = PostImage.find(params[:post_image_id])
        post_comment = PostComment.find(params[:id])
        post_comment.destroy
        redirect_to post_image_path(params[:post_image_id])
        # デストロイに渡す変数の値はどれにしたらいいの？
        # idを見つけて来る場合はfindだけではなく、その前のアクションでパラメータを取得できていれば、わざわざ変数にfindメソッドでidを渡さなくても(params[:idの記述])でidを指定できる。
        # findしたり、idを渡すためだけに変数を定義する必要がなくなるのでSQLを走らせる処理が減る。＝＞無駄を減らせる。
        # (params[:色々id])は、ただの”数字”。idのすり合わせにも使えるし、redirect先のid指定にも使える（前のアクションでしっかりとパラメータが渡っていれば）
    end

    private
    def post_comment_params
        params.require(:post_comment).permit(:comment)

    end
end
