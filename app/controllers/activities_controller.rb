class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = current_user.active_friends.push current_user
    case params[:content]
      when 'posts'
        @activities = PublicActivity::Activity.where(owner: @users, trackable_type: "Post").order(created_at: :desc)
      else
        @activities = PublicActivity::Activity.where(owner: @users).order(created_at: :desc)
    end
  end

end
