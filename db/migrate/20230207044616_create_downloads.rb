class CreateDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :downloads do |t|
      t.string :ip
      t.string :video_url

      t.timestamps
    end
  end
end
