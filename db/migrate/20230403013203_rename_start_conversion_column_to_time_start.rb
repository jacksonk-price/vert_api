class RenameStartConversionColumnToTimeStart < ActiveRecord::Migration[7.0]
  def change
    rename_column :conversions, :start_conversion, :time_start
  end
end
