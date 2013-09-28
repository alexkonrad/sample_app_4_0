class StaticPagesController < ApplicationController
  def home
		if signed_in?
			@micropost  = current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:feed_page], per_page: 15)
			@received_items = current_user.received_replies.paginate(page: params[:reply_page], per_page: 3)
			@message_items  = current_user.received_messages.paginate(page: params[:message_page], per_page: 3)
		end
  end

  def help
		@title = 'Help'
  end

	def about
		@title = 'About Us'
	end
	
	def contact
	end
end
