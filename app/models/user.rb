class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
																	 class_name:  "Relationship",
																	 dependent:		:destroy 
  has_many :followers, through: :reverse_relationships, source: :follower
	has_many :replies, foreign_key: "user_id", 
										 class_name: "Recipient",  
										 dependent: :destroy
	has_many :received_replies, :through => :replies, source: :micropost
	has_many :messages, foreign_key: "user_id",
											class_name: "Message",
											dependent: :destroy
	has_many :received_messages, :through => :messages, source: :micropost

	has_secure_password
	
	before_save { email.downcase! }
  before_create { self.notify_following = true }
	before_create :create_remember_token
  before_create :create_confirmation_token
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	VALID_UNAME_REGEX = /\A[a-z](\w*[a-z0-9])*/i

	validates :name,  presence: true, 
										format: { with: VALID_UNAME_REGEX },
										length: { maximum: 50 }
	validates :email, presence: true, 
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false } 
	validates :password, length: { minimum: 6 }

  def deactivated? 
    return !self.state
  end

  def activated? 
    return self.state
  end
  
  def activate
    self.update_attribute(:state, true)
  end
  
  def deactivate 
    self.update_attribute(:state, false)
  end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.from_users_followed_by(self).where(protected: nil)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end
	
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

  def send_confirmation
    #token = SecureRandom.urlsafe_base64.to_s
    #time  = Time.zone.now
    #self.update_attribute(:confirmation_token, token)
    #self.update_attribute(:confirmation_sent_at, time)
    UserMailer.confirmation(self).deliver
  end

  def send_password_reset
    token = SecureRandom.urlsafe_base64.to_s
    time  = Time.zone.now
    self.update_attribute(:password_reset_token, token)
    self.update_attribute(:password_reset_sent_at, time)
    UserMailer.password_reset(self).deliver
  end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

    def create_confirmation_token
      self.confirmation_token   = SecureRandom.urlsafe_base64.to_s 
      self.confirmation_sent_at = Time.zone.now
    end
end
