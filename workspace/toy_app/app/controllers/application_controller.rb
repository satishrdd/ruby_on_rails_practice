class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
   before_action :set_cache_headers
  include SessionsHelper
  def hello
  	render html: "hello,world"
  end
  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


end
