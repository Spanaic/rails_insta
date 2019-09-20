class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :name, presence: true, length: {minimum: 1, maximum: 20}
         validates :profile_name, presence: true, length: {minimum: 1, maximum: 100}

  has_many :post_images, dependent:  :destroy
  has_many :post_comments, dependent:  :destroy
  has_many :favorites, dependent:  :destroy

  attachment :profile_image
end
