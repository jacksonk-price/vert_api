class RenameEndConversionColumnToTimeEnd < ActiveRecord::Migration[7.0]
  def change
    rename_column :conversions, :end_conversion, :time_end
  end
end
