class UsersController < ApplicationController
	before_action :signed_in_user, 
								only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user,	 only: [:edit, :update]
	before_action :admin_user,		 only: :destroy

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.where(protected: nil).paginate(page: params[:page])
	end

  def new
		@user = User.new
  end

	def create
		@user = User.new(user_params)
		if @user.save
      @user.send_confirmation
			#sign_in @user
		  redirect_to root_url, notice: "Please check your email inbox for a confirmation email."
      #redirect_to @user	
		else
			render 'new'
		end
	end

  def edit
	end

	def update
    if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

  def activate
    @user = User.find_by(confirmation_token: params[:id])
    if (@user.confirmation_token == params[:id])
      if @user.confirmation_sent_at < 2.days.ago
        redirect_to root_url, :alert => "Confirmation link has expired"
      else 
        @user.update_attribute(:state, true)
        sign_in @user
        redirect_to root_url, :notice => "Your account has been activated!"
      end
    end
  end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password,
																 :password_confirmation, :notify_following)
	end

	# Before filters

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
