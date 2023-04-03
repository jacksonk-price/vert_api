class ChangeStatusColumnOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :conversions, :status, :string, after: :video_url
  end
end
