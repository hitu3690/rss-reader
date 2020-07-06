class AddUserIdToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :user_id, :integer, after: :url
  end
end
