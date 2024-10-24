class AddPreviewDataToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :preview_data, :json
  end
end
