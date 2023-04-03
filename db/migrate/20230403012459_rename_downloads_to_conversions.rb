class RenameDownloadsToConversions < ActiveRecord::Migration[7.0]
  def change
    rename_table :downloads, :conversions
  end
end
