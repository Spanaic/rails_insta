class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      # null:オプションはfalseにしておくことで、データの中が空になることを防ぐことができる
      # validatesのpresence: trueで防ぐこともできるが、SQLから直接入力されてしまうと防げないため、二重で貼っておくとセキュリティ上安全。
      t.integer :visited_id, null: false
      t.integer :post_image_id
      t.integer :post_comment_id
      t.string :action, null: false
      t.boolean :checked, null: false, default: false
      # default:オプションでfalse設定にしておくこと！通知が更新されたらtrueで返すため。

      # nilは値として、空を表現してる

      t.timestamps
    end
    add_index :notifications, :visiter_id
    add_index :notifications, :visited_id
    add_index :notifications, :post_image_id
    add_index :notifications, :post_comment_id
    # add_index　:テーブル名, :カラム名

  end
end
