class PostImagesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        # @post_images = PostImage.all
        @post_images = PostImage.page(params[:page]).per(6).reverse_order
        # kaminariでアクションごとに表示ページ数を変える場合は.per(好きな数字)をparam[:page]の後に指定する。
        @notifications = Notification.all
    end

    def new
        @post_image = PostImage.new
    end

    def show
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        # @post_comments = @post_image.post_comments
    end

    def create
        # @post_image = PostImage.new
        # 上記の変数を消すことでレンダー後のエラーメッセージの表示がうまく機能したのは、レンダー後に同じ変数名に.newしてしまうことで、レコードの中身を空にしてしまうため、エラーメッセージも空となってしまい、エラー表示がなされなくなってしまう。
        @post_image = PostImage.new(post_image_params)
        @post_image.user_id = current_user.id
        if @post_image.save
        redirect_to post_image_path(@post_image.id)
        else
            render :new
        end
    end

    def edit
        @post_image = PostImage.find(params[:id])
    end

    def update
        @post_image = PostImage.find(params[:id])
        @post_image.user = current_user
        if @post_image.update(post_image_params)
            redirect_to post_image_path(@post_image.id)
        else
            render :edit
        end
    end

    def destroy
        post_image = PostImage.find(params[:id])
        post_image.destroy
        redirect_to post_images_path
    end

    def hashtag
        # リクエストされるのはhashtagをクリックされた時だと思われる。
        @user = current_user
        @tag = Hashtag.find_by(hashname: params[:name])
        # params[:name]はrootでurlにnameが含まれるようになるからかな？
        @post_images = @tag.post_images.build
        # buildは外部キーを含む.newを行う際にわかりやすいので使用されている
        @post_image = @tag.post_images.page(params[:page])
        # @comment    = Comment.new
        # @comments   = @post_images.comments
    end

    # 後半の数行はイメージが沸かないので実装後に確認する
    # 記事の筆者と変数の記述が違うのでcommentのところは書き換える必要があると思われる。

    def reply
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        render :show
    end

    private
    def post_image_params
        params.require(:post_image).permit(:post_image, :caption)
    end
end