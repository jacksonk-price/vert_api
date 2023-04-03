class AddStatusMessageColumnToConversions < ActiveRecord::Migration[7.0]
  def change
    add_column :conversions, :status_message, :text
  end
end
