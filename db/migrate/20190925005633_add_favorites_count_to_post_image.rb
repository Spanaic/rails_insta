class AddFavoritesCountToPostImage < ActiveRecord::Migration[5.2]
  def change
    add_column :post_images, :favorites_count, :integer
  end
end
