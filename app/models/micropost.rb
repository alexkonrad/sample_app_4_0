class Micropost < ActiveRecord::Base
	belongs_to :user

	USERNAME_REGEX = /@\w+/i
	MESSAGE_REGEX  = /dm\s@\w+/i

	has_many :recipients, dependent: :destroy
	has_many :replied_users, :through => :recipients, :source => "user"

	has_many :messages, dependent: :destroy
	has_many :messaged_users, :through => :messages, :source => "user"

	scope :from_users_followed_by, ->(user) { followed_by(user) }

	after_save :save_messages
	after_save :save_recipients
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
		
		def people_replied
			users = []
			self.content.clone.gsub!( USERNAME_REGEX ).each do |username|
				user = User.find_by_name(username[1..-1])
				users << user if user
			end
			users.uniq
		end

		def person_messaged
			users = []
			self.content.clone.gsub!( MESSAGE_REGEX ) do |username|
				user = User.find_by_name(username[4..-1])
				users << user if user
			end
			users.uniq
		end

	private

		def self.followed_by(user)
			followed_ids = "SELECT followed_id FROM relationships
											WHERE follower_id = :user_id"
			replier_ids = "SELECT micropost_id FROM recipients
										   WHERE user_id = :user_id"
			where("user_id in (#{followed_ids}) 
						 OR id in (#{replier_ids}) 
						 OR user_id = :user_id", 
						 user_id: user.id)
		end

		def save_recipients
			return unless reply?

			people_replied.each do |user|
				Recipient.create!(micropost_id: self.id, user_id: user.id)
			end
		end

		def save_messages
			return unless message?

			person_messaged do |user|
				Message.create!(micropost_id: self.id, user_id: user.id)
			end
		end

		def reply?
			self.content.match( USERNAME_REGEX )
		end
	
		def message?
			self.content.match( MESSAGE_REGEX )
		end
=begin
		def people_replied
			users = []
			self.content.clone.gsub!( USERNAME_REGEX ).each do |username|
				user = User.find_by_name(username[1..-1])
				users << user if user
			end
			users.uniq
		end

		def person_messaged
			users = []
			self.content.clone.gsub!( MESSAGE_REGEX ) do |username|
				user = User.find_by_name(username[1..-1])
				users << user if user
			end
			users.uniq
		end
=end
end
