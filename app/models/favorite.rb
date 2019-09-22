class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :post_image
    # アソシエーションを組む時はちゃんと確認すること！

    # belongs_toが2つということは、多対多の関係となっているため、このモデルは中間テーブルとして機能すると考える。
    # 中間テーブルとしてネストされていると、params[:id]のレコードにアソシエーションされた情報を一括で取得することができる。
    # current_userやviewに渡されている変数を利用すれば,そこに関連したfavoriteの情報を引き出すこともできる。
end
