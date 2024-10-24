class AddCreatorToChatRooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_rooms, :creator, foreign_key: { to_table: :users }

    reversible do |dir|
      dir.up do
        default_user_id = User.first&.id || 1
        ChatRoom.where(creator_id: nil).update_all(creator_id: default_user_id)
      end
    end

    change_column_null :chat_rooms, :creator_id, false
  end
end
