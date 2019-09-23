class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.string :hashname
      t.timestamps
    end
    add_index :hashtags, :hashname, unique: true
    # add_index :テーブル名, :カラム名, unique:　任意
    # カラムにindexを追加すると,カラムの中が追加順ではなくindexのアルファベットなどの昇順で管理され、検索などの時間が短縮される
    # デメリットは、DBに書き込む速度が二倍ほどかかる（低下する）
    # データベースが長大になる場合はindexを付与しておくと吉。
    # unique:オプションをtrueにすると、一意の値しか登録出来なくなる。同じ値を重複して登録出来なくなる。
  end
end
