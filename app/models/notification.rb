class Notification < ApplicationRecord
    default_scope -> { order(created_at: :desc) }
    # discじゃなくてdesc
    # データベースを最新の作成日時順に並ばせる
    belongs_to :visitor, class_name: 'User', foreign_key: :visitor_id, optional: true
    belongs_to :visited, class_name: 'User', foreign_key: :visited_id, optional: true
    # optional => optinalに打ち間違えてる
    # migrationファイルで null: falseを設定しているのにoptional: true に設定するのはなぜ？
    # optional: true　＝＞　外部キーの制約を外す。
    # 外部キーの制約を外すことで、nilの状態でもレコードを作成できるようにする。
    # 親モデルの作成前に、optional: trueを設定してDBへの保存を一時的に可能にするなどの使い方。
    belongs_to :post_image, optional: true
    # いいねの通知のためにpost_imageとリレーションを組むため、favoriteは要らない。
    belongs_to :post_comment, optional: true
end
