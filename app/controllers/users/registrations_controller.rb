class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up, :account_update).push(:username)
    devise_parameter_sanitizer.for(:account_update).push(:current_password, :age, :bio, :gender)
  end
end