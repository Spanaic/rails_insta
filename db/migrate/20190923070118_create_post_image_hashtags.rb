class CreatePostImageHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_image_hashtags, id: false do |t|
      # 参照URL通りに行くと、create_table :hashtags_post_images, id: false do |t|
      # id: falseをすることでマスタIDをなくす事ができる
      # 主キー（primary_key）がIDではない場合、自動生成されなくされる
      t.references :post_image_id, index: true, foreign_key: true
      t.references :hashtag_id, index: true, foreign_key: true
    end
  end
end
