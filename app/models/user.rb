class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
        #  omuniauthtableを追加する
        #  :omniauthtableをONにする

         validates :name, presence: true, length: {minimum: 1, maximum: 20}
         validates :profile_name, presence: true, length: {minimum: 1, maximum: 100}
        # facebook認証で必要な項目、以外でvalidatesを掛けていると（今回の場合はprofile_name）createメソッドが実行される際に、必要なカラムが埋まらず（今回はpresence: trueをしていたため）rollbackされてしまう。
        # カラムに必要な情報が渡っているか、validatesが渡す情報の邪魔をしていないか要チェック

        # nameとprofile_nameにauth.info.nameの情報を渡してみてはいかが？

  has_many :post_images, dependent:  :destroy
  has_many :post_comments, dependent:  :destroy
  has_many :favorites, dependent:  :destroy

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
        profile_name:  auth.info.name,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    # 変数userに代入できるuidがない場合は、createメソッドをuserに代入する
    # Userモデル内のカラムを指定:  =>  facebookから渡されるinfoを記述（参考はgithub）
    # passwordは0 - 20 桁で自動生成させることで完了。

    user
  end

end
