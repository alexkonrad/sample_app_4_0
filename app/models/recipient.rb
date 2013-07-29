class Recipient < ActiveRecord::Base
	belongs_to :user
	belongs_to :micropost

	scope :replying_to, ->(user) { where("user_id = ?", user.id) }
end
