class EndUser < ApplicationRecord
  has_and_belongs_to_many :post_comments

  has_many :post_images, dependent:  :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent:  :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent:  :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key:  :follower_id, dependent:  :destroy
  has_many :followers, through: :passive_relationships, source: :following

  has_many :active_notifications, class_name: "Notification", foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: :visited_id, dependent: :destroy

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  def create_notification_follow(current_user, end_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, end_user.id, 'follow'])
      notification = current_user.active_notifications.new(
        visited_id: end_user.id,
        action: 'follow',)

      notification.save if notification.valid?
  end
end
