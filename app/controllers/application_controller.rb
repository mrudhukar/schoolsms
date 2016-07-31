class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout :set_layout

  helper_method :current_tab

  def current_tab
    @tab
  end

  def set_layout
    user_signed_in? ? "application" : "public"
  end
end
