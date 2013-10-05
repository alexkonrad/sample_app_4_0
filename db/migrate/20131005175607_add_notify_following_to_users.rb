class AddNotifyFollowingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_following, :boolean
  end
end
