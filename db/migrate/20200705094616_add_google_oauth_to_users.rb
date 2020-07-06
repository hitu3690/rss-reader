class AddGoogleOauthToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_digest, :string, after: :password_digest
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :image, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end
