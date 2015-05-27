class PagesController < ApplicationController
  def home
    if current_user
      respond_to do |format|
        format.html { redirect_to activities_path }
      end
    end
  end
end
