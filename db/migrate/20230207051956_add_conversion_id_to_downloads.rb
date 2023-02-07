class AddConversionIdToDownloads < ActiveRecord::Migration[7.0]
  def change
    add_column :downloads, :conversion_id, :string
  end
end
