class NotificationsController < ApplicationController
    def index
        @notifications = current_user.passive_notifications.page(params[:page]).per(20)
        # current_userをpassiveしてvisited_idを埋める。通知を受ける人の値をすべて取得する。ページネーション付き
        @notifications.where(checked: false).each do |notification|
            # 受け取った値のうち、checked:カラムがfalseの値をすべて取得して.eachする
            notification.update(checked: true)
            # .updateメソッドで（変更したいカラム名: 変更したい値）
        end
    end
end
