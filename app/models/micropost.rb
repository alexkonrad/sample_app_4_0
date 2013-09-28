class Micropost < ActiveRecord::Base
	belongs_to :user

	USERNAME_REGEX = /@\w+/i
	MESSAGE_REGEX  = /dm\s@\w+/i

	has_many :recipients, dependent: :destroy
	has_many :replied_users, :through => :recipients, :source => "user"

	has_many :messages, dependent: :destroy
	has_many :messaged_users, :through => :messages, :source => "user"

	scope :from_users_followed_by, ->(user) { followed_by(user) }

  before_save :check_protected
	after_save :save_recipients
	after_save :save_messages
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
		
	private

		def self.followed_by(user)
			followed_ids = "SELECT followed_id FROM relationships
											WHERE follower_id = :user_id"
			where("user_id IN (#{followed_ids}) 
						 OR user_id = :user_id", 
						 user_id: user.id)
		end
		
    def check_protected
      return unless message?

      self.protected = true
    end

		def save_recipients
			return unless reply? && !message?

			people_replied.each do |user|
				Recipient.create!(micropost_id: self.id, user_id: user.id)
			end
		end

		def save_messages
			return unless message?

			people_messaged.each do |user|
				Message.create!(micropost_id: self.id, user_id: user.id)
			end
		end

		def reply?
			self.content.match( USERNAME_REGEX )
		end
	
		def message?
			self.content.match( MESSAGE_REGEX )
		end
		
		def people_replied
			users = []
			self.content.clone.gsub!( USERNAME_REGEX ).each do |username|
				user = User.find_by_name(username[1..-1])
				users << user if user
			end
			users.uniq
		end

		def people_messaged
			users = []
			self.content.clone.gsub!( MESSAGE_REGEX ) do |username|
				user = User.find_by_name(username[4..-1])
				users << user if user
			end
			users.uniq
		end
end
