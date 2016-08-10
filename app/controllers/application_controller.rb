class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_filter -> { 
    flash.now[:notice] = flash[:notice].html_safe  if flash[:notice]
    flash.now[:alert] = flash[:alert].html_safe if flash[:alert]
  }

  layout :set_layout

  helper_method :current_tab

  def current_tab
    @tab
  end

  def set_layout
    user_signed_in? ? "application" : "public"
  end
end
