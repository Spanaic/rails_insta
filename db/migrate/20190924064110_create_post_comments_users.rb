class CreatePostCommentsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comments_users, id: false do |t|
      t.references :post_comment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
