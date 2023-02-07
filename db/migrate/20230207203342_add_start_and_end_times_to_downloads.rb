class AddStartAndEndTimesToDownloads < ActiveRecord::Migration[7.0]
  def change
    add_columns :downloads, :start_conversion, :end_conversion, type: :datetime
  end
end
