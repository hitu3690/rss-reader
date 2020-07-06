class CreateFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :feeds do |t|
      t.text :url
      t.integer :sort_id

      t.timestamps
    end
  end
end
