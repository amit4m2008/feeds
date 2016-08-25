class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.text :feed_url

      t.timestamps null: false
    end
  end
end
