class PostCommentsUser < ApplicationRecord
  belongs_to :post_comment_id
  belongs_to :user_id

  validates :post_comment_id, presence: true
  validates :user_id, presence: true
end
