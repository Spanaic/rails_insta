Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "post_images#index"

  get '/post/hashtag/:name', to: "post_images#hashtag"
  # ハッシュタグのリンクに飛ぶためのルーティング
  # post_imagesコントローラのhashtagアクションメソッドが呼び出される

  # get '/users/reply/:name', to: "users#reply_user"

  resources :post_images do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    # resource"s"はidを与えるかどうか。viewを作るかどうかが問題ではない。
    # :destroyする時には必ずIDを指定しなければならず、そうするとresource's'とすることでidを付与することができ、削除する対象を'path'で指定できるようになる。
    # URLを参照したときに、/idではなく.idなどの表示になる場合は、indexのpathに必要のないidを指定したときなどに起こるバグ。
    get :reply, on: :member
  end

  # ネストすることで、親のidを指定したり、チーム開発で無用な混乱を招く必要がなくなるのでネストは大事。
  # テーブル数が10~20個ほどになったときに、アクション内の書き方が複雑化するが、ネストしておくと記述量が少し減る。

  resources :users, param: :profile_name, only: [:edit, :index, :update, :show, :index] do
    resource :relationships, param: :profile_name, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member

    # get :pathの名前が入ってる。ネストされているのでpathはfollows_user_path,followers_user_pathとなる
    # resourceの時は:コントローラを指定しているので要注意！
    # resource内に別のルート（アクション）を追加したい場合はcollectionかmemberを用いる
    # collectionは(id無し),memberは（idあり）のurl生成される
    # follow関係のindexを、別アクションで代わりに作ったイメージ
    # 自己結合多対多は自己の中心にルートを取って行くのが良さそう。（ネストで機能、自己にルート）

    # get :reply_user, on: :member
    # 多分要らない↑↑↑
  end
  resources :notifications, only: [:index]
end