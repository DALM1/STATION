class AddDescriptionToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :description, :string
  end
end
