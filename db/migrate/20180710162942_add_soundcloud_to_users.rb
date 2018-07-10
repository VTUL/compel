class AddSoundcloudToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :soundcloud_handle, :string
  end
end
