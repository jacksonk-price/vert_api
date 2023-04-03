class ChangeStatusMessageColumnOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :conversions, :status_message, :string, after: :status
  end
end
