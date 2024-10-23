class Post < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user
  has_many :threads, class_name: "ThreadMsg", dependent: :destroy
end
