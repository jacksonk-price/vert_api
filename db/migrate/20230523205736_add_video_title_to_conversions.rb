class AddVideoTitleToConversions < ActiveRecord::Migration[7.0]
  def change
    add_column :conversions, :video_title, :string
  end
end
