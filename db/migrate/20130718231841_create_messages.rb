class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :user_id
      t.string :micropost_id

      t.timestamps
    end
  end
end
