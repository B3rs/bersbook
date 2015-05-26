class UsersController < ApplicationController
	before_action :authenticate_user!, only:[:index]
	before_action :set_user, only: [:show]

	def show
    @posts = @user.posts.order(created_at: :desc)
    @activities = PublicActivity::Activity.where(owner: @user).order(created_at: :desc)
	end
	
	def index
		case params[:people] 
		when "friends"
			@users = current_user.active_friends
		when "requests"
			@users = current_user.friendships.pending.includes(:friend).map(&:friend)
		when "pending"
			@users = current_user.inverse_friendships.pending.includes(:user).map(&:user)		
		else
			@users = User.where.not(id: current_user.id)
		end
	end

	private

	def set_user
		@user = User.includes(:posts).find_by(username: params[:id])
  end
end
