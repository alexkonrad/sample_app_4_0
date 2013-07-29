class AddProtectedToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :protected, :boolean
  end
end
