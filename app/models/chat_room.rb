class ChatRoom < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :posts, dependent: :destroy
  has_one_attached :image

  validates :password, presence: true, if: :password_required?

  private

  def password_required?
    password.present?
  end
end
