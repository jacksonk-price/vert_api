class RemoveConversionIdFromConversions < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversions, :conversion_id
  end
end
