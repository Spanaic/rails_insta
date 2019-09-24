class PostImageHashtag < ApplicationRecord
    belongs_to :post_image
    belongs_to :hashtag

    validates :post_image_id, presence: true
    validates :hashtag_id, presence: true
    # validatesを各idに指定しているのは、セキュリティや例外が発生しないようにするため？と思われる。
end
