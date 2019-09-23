class PostImagesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        # @post_images = PostImage.all
        @post_images = PostImage.page(params[:page]).per(6).reverse_order
        # kaminariでアクションごとに表示ページ数を変える場合は.per(好きな数字)をparam[:page]の後に指定する。
    end

    def new
        @post_image = PostImage.new
    end

    def show
        @post_image = PostImage.find(params[:id])
        @post_comment = PostComment.new
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

    private
    def post_image_params
        params.require(:post_image).permit(:post_image, :caption)
    end
end