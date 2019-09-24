class Hashtag < ApplicationRecord
    has_and_belongs_to_many :post_images
    # 複数形で記述する
    validates :hashname, presence: true, length: {maximum: 99}
    # 名前付けには空欄NG、最大文字数をinstagramと同様の99文字に制限
end
