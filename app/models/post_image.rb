class PostImage < ApplicationRecord
    has_many :post_comments, dependent:  :destroy
    has_many :favorites, dependent:  :destroy
    belongs_to :user
    attachment :post_image

    validates :post_image, presence: true
    validates :caption, presence: true, length: {minimum: 5, maximum: 140}

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end
        # favorited_byメソッドはいいねをしているかどうかを確認する
        # 引数に入ってる値が、いいねをしているかどうか
        # 引数の値は.whereメソッドで存在が確認された値から確認される
        # favoritesモデル内のuser_idとuserモデル内のidを突き合わせて、存在する=true,存在しない=falseで返す。＝＞existsの説明
end

# アソシエーションがうまくできていないと、favorited_by?メソッドでuninitialized constantのエラーが発生する可能性がある。
