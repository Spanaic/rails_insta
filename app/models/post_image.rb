class PostImage < ApplicationRecord
    has_many :post_comments, dependent:  :destroy
    has_many :favorites, dependent:  :destroy
    belongs_to :user
    has_and_belongs_to_many :hashtags

    # has_and_belongs_to_manyは中間テーブルにモデルが必要ない(処理を記述する必要がない)場合に、シンプルに中間手＝ブルを除いたアソシエーションを”主対主”で行うことができる
    # 中間モデルに処理を記述する場合にはhas_many through:で　中間モデルをbelongs_to x2でつないであげる記述を行うことができる。
    # 中間テーブルにIDを持たせる場合はthroughにしたほうが良いのかも…
    # 中間テーブルにもアソシエーションの記述は必要。

    has_many :notifications, dependent: :destroy

    attachment :post_image

    validates :post_image, presence: true
    validates :caption, presence: true, length: {maximum: 140}

    def favorited_by?(current_user)
        favorites.where(user_id: current_user.id).exists?
    end
    # favorited_by?メソッドに変数が正しく渡せてなかったのが原因で、if文の条件分岐をうまく活用できず、同じユーザが何回でもいいねできるようになっていた。
    # createとdestroyメソッドはうまく動いていたので、それ以外の場所を注意深く見ることも大事。
    # パーシャルに渡す変数を定義している場所はしっかりと把握しておくこと。

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

    def create_notification_favorite(current_user)
        temp = Notification.where(["visitor_id = ? and visited_id = ? and post_image_id = ? and action = ?", current_user.id, user_id, id, 'favorite'])
        # visitor = いいねした人　visited　＝　いいねされた人 post_image = params action = like =>左の条件に当てはまるレコードを引っ張る
        if temp.blank?
            # .blankメソッドは.nil=値, empty=入れ物が空, .blank=値or入れ物が空
            # notification = Notification.new(visitor_id: current_user, visited_id: user_id, post_image_id: params[:id], action: 'like')
            # current_userをvisitor_idで受け取らせるためにactive_notificationsを選択する。
            # .where([","])メソッドで何もヒットしなければ.newメソッドを行う。
            notification = current_user.active_notifications.new(visited_id: user_id, post_image_id: id, action: 'favorite')
            if notification.visitor_id == notification.visited.id
                # 基本的に自分の投稿にもいいねできるので、自分の投稿には通知をさせないように条件を設けている。
                # 通知を確認するアクションをすると,そのレコードのvisited_idのカラムに値がinsertされる（後ほど設定）
                notification.checked = true
                # 通知がcreateされたdfaultの状態だとfalseとなる。丸ポッチの表示切り替えに使用
                # 通知確認のアクションが実行されたなら'checked'カラムの値をtrueに変更
                # trueの変更に対して条件分岐で通知の丸ポッチの表示をoffにする記述を追加する。
            end
            notification.save if notification.valid?
            # .valid?のバリデーションはmigrationファイルで記述したnull: falseのことかな？
            # end
        end
    end
            # def create_notification_post_comment(current_user)
            #     temp = Notification.where(["visitor_id = ? and visited_id = ? and post_image_id = ? and post_comment_id = ? and action = ?, current_user, user_id, params[:id], post_image.post_comment.id, 'comment"])
            #     if temp.blank
            #         notification = current_user.active_notifications.new(
            #             visited_id: user_id,
            #             post_image_id: params[:id],
            #             post_comment_id:
            #             action: 'comment'
            #         )
            #         if notification.visitor_id == norification.visited_id
            #             notification.checked = true
            #         end
            #         notification.save if notification.valid?
            #     end
            # end
            # コメントの通知機能はいいねと違い、何回でもコメントができるため存在確認をしない。

    def create_notification_post_comment(current_user, post_comment_id)
        # 引数にcomment_idを入れられるのは,アクションのタイミングの関係？idの特定方法とは？
        # モデル内のメソッドは引数が設置されている。コントローラでメソッドを呼び出した際に渡される変数が引数へと代入される。
        # ()内はすべて引数。渡される変数は呼び出すコントローラのアクションメソッド内を確認する。

        # 引数はあくまで名前なので、メソッド呼び出し時に引数を渡してあげなければならない。

        temp_ids = PostComment.select(:user_id).where(post_image_id: id).where.not(user_id: current_user.id).distinct
        # .select(:user_id) = PostCommentモデルからuser_idを持ってきてね
        # .where(post_image_id: params[:id]) = パラメータが渡されるのはコントローラでメソッドが呼び出された時なので、引数に渡される予定のインスタンス変数からidを引っ張ってくる想定で記述をする方がベター。
        # .where.not(user_id: current_user.id) = currennt_userのcommentを除く
        # .distinct = 同じuserのコメントは通知が重複するからやめてね
        # もしかしたら、コメントに対する返信機能が実装されているため、.select以下の記述をされている可能性あり
        temp_ids.each do |temp_id|
            # temp_id＝中身はselectで取り出した（user_id）と（post_comment_id=createアクションメソッドで渡されるため、現状はnil）
            # つまり、temp_ids=user_id(とpost_comment_id)が配列で代入されている。
            save_notification_post_comment(current_user, @new_post_comment, temp_id['user_id'])
            # temp_id.save_notification_post_commentはできない。temp_idは渡された配列を.eachした数字のため。（インスタンスではないため）
            # 実際に変数が渡される箇所は、渡されるインスタンス変数名を間違いなく記述する。
            # モデルに渡される変数はすべてインスタンス変数！(じゃないと変数が渡らない)
        end
        save_notification_post_comment(current_user, @new_post_comment, user_id) if temp_ids.blank?
        # .select.whereで探したけど、該当のユーザが存在しない場合（コメントがない場合）投稿者に通知を送る。
        # 引数のuser_idは、createアクションメソッド内の変数post_image.user_idから渡している。
        # post_commentsコントローラの変数をローカル変数にしないとエラーが出ると思う（現在グローバル変数のため）
        # end
    end

            # モデル内に定義したメソッドはインスタンスメソッドなのか、クラスメソッドなのかを理解する
            # クラスメソッド＝self.メソッド名　＝　modelに対して使用できるメソッドとして定義される。他のコントローラ内でも利用可能
            # クラスメソッド＝クラス全体から呼び出すメソッド
            # インスタンスメソッド＝ モデル内の特定のインスタンスを呼び出すメソッド（変数に対してなどで使われる。）

    def save_notification_post_comment(current_user, comment_id, visited_id)
        # ()内はすべて引数。メソッド内の変数名と引数名を合わせておけば、アクションメソッドで渡された引数がメソッド内に代入される（カラム内にcreateに必要な情報が渡される）
        # 引数と変数を混同しないように気をつける。

        notification = current_user.active_notifications.new(
            visited_id: user_id,
            post_image_id: id,
            post_comment_id: comment_id,
            action: 'comment',
        )
        if notification.visitor_id == notification.visited_id
            notification.checked = true
        end
        notification.save if notification.valid?
        # end
        # ifが途中で入る時はendで閉じなくても良い
    end
    # モデル内にメソッドを定義しておくことでVCで呼び出す（変数.create_notification_favorite）ことができるようになる。
    # 引数に指定してるuserがcurrent_userと決まっている場合は引数として設定してもいいけど、そうでない場合はメソッド使用時に設定してもいい。
end

# アソシエーションがうまくできていないと、favorited_by?メソッドでuninitialized constantのエラーが発生する可能性がある。

