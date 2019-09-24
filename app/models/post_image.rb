class PostImage < ApplicationRecord
    has_many :post_comments, dependent:  :destroy
    has_many :favorites, dependent:  :destroy
    belongs_to :user
    has_and_belongs_to_many :hashtags

    # has_and_belongs_to_manyは中間テーブルにモデルが必要ない(処理を記述する必要がない)場合に、シンプルに中間手＝ブルを除いたアソシエーションを”主対主”で行うことができる
    # 中間モデルに処理を記述する場合にはhas_many through:で　中間モデルをbelongs_to x2でつないであげる記述を行うことができる。
    # 中間テーブルにIDを持たせる場合はthroughにしたほうが良いのかも…
    # 中間テーブルにもアソシエーションの記述は必要。

    attachment :post_image

    validates :post_image, presence: true
    validates :caption, presence: true, length: {maximum: 140}

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end

    # 下村さんより
    # モデルに記述することで、PostImage.find等と同じようにメソッドとして、どこでも使用することができるようになる。今回はviewの条件分岐で呼び出すためにモデルに記述されている。
    # 基本的にモデルにはたくさん記述を増やしてもいいけど、viewに条件分岐の記述を増やしたり、コントローラの記述を増やすのは好まれないため、モデルに記述することができるものはなるべくモデルに記述していく。

        # favorited_byメソッドはいいねをしているかどうかを確認する
        # 引数に入ってる値が、いいねをしているかどうか
        # 引数の値は.whereメソッドで存在が確認された値から確認される
        # favoritesモデル内のuser_idとuserモデル内のidを突き合わせて、存在する=true,存在しない=falseで返す。＝＞existsの説明

    # ハッシュタグ用の記述をここから開始
    after_create do
        post_image = PostImage.find_by(id: self.id)
        # selfはモデル内のクラスインスタンスを指す。今回でいうと'PostImage'のこと
        hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
        # PostImage.caption.scanと同義。
        # .scanメソッドは引数に入ってる正規表現の文字列を取得してきて、配列として返す
        hashtags.uniq.map do |hashtag|
            # .uniqメソッドは.distinctメソッドに置き換わる予定。同じ値を一つにまとめるメソッド
            # .mapは.eachのように配列を順に変数に代入していくメソッド
            # .eachと違い変数に代入された値の戻り値にメソッドを反映させることができる
            # 変数hashtagsの配列の要素をブロック変数'hashtag'へと代入している
            tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
            # .find_or_create_byメソッドは変数をkeyとなるカラムから探すandなければ新規作成するメソッド（create）
            # .find_or_initialize_byメソッドという似たようなメソッドがあるが、こちらは（new）までを行う。つまり探して、なければ空のレコードを作成するが保存はしない。
            # .downcaseメソッドは文字列.downcaseで大文字を小文字に変換しても戻り値として返すメソッド
            # .delete(引数)はStrの値の中に含まれる引数の値をdeleteするメソッド
            post_image.hashtags << tag
            # 左辺 << 右辺　＝＞　左辺の配列の末尾に右辺の値を破壊的に追加してくれる。

            # 記号によって渡されたtagが中間テーブルを通る時に、テーブル名が命名規則（アルファベット順）に則ってなかったため、couldn't find tableがエラーで吐き出されていた。
            # table名を正しく記述することでエラーは解決された。

            # no method errorの場合はvalidationが影響しているかどうかも確認をする。
        end
    end

    before_update do
        post_image = PostImage.find_by(id: self.id)
        post_image.hashtags.clear
        # .clearメソッドは配列の要素を一度空にする。戻り値は空。
        # .updateアクションの前に行われることで、一度保存されているpost_image[:id]に関連したハッシュタグをすべて空っぽにしている
        hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
        hashtags.uniq.map do |hashtag|
            tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
            post_image.hashtags << tag
        end
    end
    # イマイチこれでハッシュタグまで一緒に更新できるのか怪しい。
    # railsのコールバック機能を使ってDBに保存した直後（createアクション直後）に、ハッシュタグを抽出してhashtagテーブルに保存する処理を施す。
end

# アソシエーションがうまくできていないと、favorited_by?メソッドでuninitialized constantのエラーが発生する可能性がある。
