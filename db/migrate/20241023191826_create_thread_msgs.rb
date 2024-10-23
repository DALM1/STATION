class CreateThreadMsgs < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_msgs do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
