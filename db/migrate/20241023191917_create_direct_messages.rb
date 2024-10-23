class CreateDirectMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :direct_messages do |t|
      t.text :content
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
