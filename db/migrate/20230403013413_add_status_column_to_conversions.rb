class AddStatusColumnToConversions < ActiveRecord::Migration[7.0]
  def change
    add_column :conversions, :status, :string
  end
end
