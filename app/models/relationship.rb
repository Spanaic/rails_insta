class Relationship < ApplicationRecord
    # 中間モデルであるrelationship内にUserモデルとのアソシエーションを記述する。
    # 自己結合多対多なのでUserモデルをわかりやすく2つの属性に分割する
    # class_name:オプションでモデル名を大文字で指定する
    # 変更したいクラス名をbelongs_toの後に記述する
    belongs_to :following, class_name: "User"
    # 自己結合多対多は同じモデルに対して、複数のつながりを持つため、結合元と結合先を2つとも命名して、アソシエーションを組む
    belongs_to :follower, class_name: "User"
end
