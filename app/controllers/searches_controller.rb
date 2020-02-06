class SearchesController < ApplicationController
  def index
    post_images = PostImage.where("title LIKE ?", "%#{params[:search]}%").or(PostImage.where("caption LIKE ?", "%#{params[:search]}%"))

    search_results = post_images.to_json(include: [:favorites, :end_user, :hashtags, :notifications, :post_comments => {:include => :end_user}])
    render :json => search_results
  end
end