class CreateScrapedInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :scraped_infos do |t|
      t.json :data, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
