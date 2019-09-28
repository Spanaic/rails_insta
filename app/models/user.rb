class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
        #  omuniauthtableを追加する
        #  :omniauthtableをONにする

         validates :name, presence: true, length: {minimum: 1, maximum: 20}
         validates :profile_name, presence: true, format: { with: /\A[a-zA-Z\d]+\z/ }, length: {minimum: 1, maximum: 100}

        # facebook認証で必要な項目、以外でvalidatesを掛けていると（今回の場合はprofile_name）createメソッドが実行される際に、必要なカラムが埋まらず（今回はpresence: trueをしていたため）rollbackされてしまう。
        # カラムに必要な情報が渡っているか、validatesが渡す情報の邪魔をしていないか要チェック

        # nameとprofile_nameにauth.info.nameの情報を渡してみてはいかが？
  has_and_belongs_to_many :post_comments

  has_many :post_images, dependent:  :destroy
  has_many :post_comments, dependent:  :destroy
  has_many :favorites, dependent:  :destroy

  # relationshipを2つhas_manyで定義しなくてはいけないため、わかりやすい名前をclass_name:オプションで指定してあげる。
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent:  :destroy
  # 自己結合多対多では中間テーブルも疑似クラス名で,モデルを2つに分けてアソシエーションを組む。
  # foreign_keyとは親のモデルのprimary_key(マスタID)のこと
  # 中間テーブルを2つに分ける際に、Userモデルから受け取ったprimary_keyをforeign_keyとしてどのカラムに保存するか指定する(それによって擬似クラス名の名前や使い方が変わってくる)
  # activeなのでフォローする人としてforeign_keyにidを入れていくモデルとする。

  has_many :followings, through: :active_relationships, source: :follower
  # sourceの'follower'はrelationshipモデルで付けた擬似クラス名
  # activeと付けた擬似クラス名を通して、フォローされた側を集めること　＝＞userが今フォローしてる人たちを集めることをfollowingsと定義している。

  has_many :passive_relationships, class_name: "Relationship", foreign_key:  :follower_id, dependent:  :destroy
  has_many :followers, through: :passive_relationships, source: :following

  # モデルfollowersを指定してデータを引っ張ってくると,フォロワー(follower)を1としてフォローしている人たち(following)を集めて来る事ができる。
  # passive_relationshipsをthroughすることで、どっちのforeign_keyにidが入るか決まるため、それに紐付いたレコードをすべて取得することができる

  has_many :active_notifications, class_name: "Notification", foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: :visited_id, dependent: :destroy

  def followed_by?(user)
    # フォロワーから見て、フォローしている人の中に同じIDのユーザがいるかどうかを調べる。
    # foreign_key(フォロワーのid)が入ってるテーブルを参照して、該当のフォローしている人(folowing)を探して集める。
    # その中に引数userに入っているidとpassive_relationshipsのfollowing_idを照らし合わせて存在するかしないかを確認するメソッド
    # 何度も言うけど,passiveだからfollowed_idは埋まってるよ。
    passive_relationships.find_by(following_id: user.id).present?
    # .presentメソッドは、モデルから指定されたカラムの配列を作り出して、配列に空がないかどうか調べるメソッド
    # 一度配列を作るので、処理に時間がかかる可能性がある
    # .exists?などは指定されたカラムを見て、該当するidなどがあればその時点でtrueを返すため、処理が早くなりそう。
    # whereではexists,find_byではpresentの方が効率が良いとか、決まりがあるのかな？
  end

  attachment :profile_image

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    # 最初にuidの存在をUserモデルから探しに活かせる
    # 探すのはuidとproviderで、その条件にヒットするユーザかどうかを条件分岐
    # facebook側による認証がfacebookページで最初に行われる
    # facebook側から受け取ったuid、providerを元にUserモデルにwhereメソッドを実行する。

    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        name:     auth.info.name,
        profile_name:  auth.uid,
        # profile_image_id: auth.info.image,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    # 変数userに代入できるuidがない場合は、createメソッドをuserに代入する
    # Userモデル内のカラムを指定:  =>  facebookから渡されるinfoを記述（参考はgithub）
    # passwordは0 - 20 桁で自動生成させることで完了。

    user
  end

  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow',)

      notification.save if notification.valid?
    end
  end

# if notification.visitor_id == notification.visited_id
    # notification.checked = true
# end
# 上記の記述がつかないのはフォロー機能で自分をフォローできないように記述しているはずだから。

end
