class AddImageAndPasswordToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :image, :string
    add_column :chat_rooms, :password, :string
  end
end
