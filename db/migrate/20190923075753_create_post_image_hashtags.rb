class CreatePostImageHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags_post_images, id: false do |t|
      # テーブルの命名規則を調べる。　＝＞　アルファベット順にテーブルを命名する
      # 参照URL通りに行くと、create_table :hashtags_post_images, id: false do |t|
      # id: falseをすることでマスタIDをなくす事ができる
      # 主キー（primary_key）がIDではない場合、自動生成されなくされる
      t.references :post_image, index: true, foreign_key: true
      t.references :hashtag, index: true, foreign_key: true
      # referencesは_idを省略して記述する
    end
  end
end
