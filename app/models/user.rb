class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :direct_messages_sent, class_name: "DirectMessage", foreign_key: "sender_id"
  has_many :direct_messages_received, class_name: "DirectMessage", foreign_key: "receiver_id"
  has_many :notifications
  has_one_attached :avatar
  validates :username, presence: true, length: { maximum: 20 }, allow_nil: true
end
