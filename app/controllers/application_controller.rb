class ApplicationController < ActionController::Base
  include ::Pundit::Authorization
  include ::Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
