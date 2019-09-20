class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :post_image
    # アソシエーションを組む時はちゃんと確認すること！
end
