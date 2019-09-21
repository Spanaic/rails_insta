Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "post_images#index"

  resources :post_images do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    # resource"s"はidを与えるかどうか。viewを作るかどうかが問題ではない。
    # :destroyする時には必ずIDを指定しなければならず、そうするとresource's'とすることでidを付与することができ、削除する対象を'path'で指定できるようになる。
    # URLを参照したときに、/idではなく.idなどの表示になる場合は、indexのpathに必要のないidを指定したときなどに起こるバグ。
  end

  # ネストすることで、親のidを指定したり、チーム開発で無用な混乱を招く必要がなくなるのでネストは大事。
  # テーブル数が10~20個ほどになったときに、アクション内の書き方が複雑化するが、ネストしておくと記述量が少し減る。

  resources :users, only: [:edit, :index, :update, :show] do
  end
end
