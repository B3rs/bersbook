class ApplicationController < ActionController::Base
  helper_method :requests_count
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def requests_count
    current_user.friendships.pending.includes(:friend).map(&:friend).count
  end
end
