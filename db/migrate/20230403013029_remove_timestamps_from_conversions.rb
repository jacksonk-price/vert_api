class RemoveTimestampsFromConversions < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversions, :created_at, :string
    remove_column :conversions, :updated_at, :string
  end
end
