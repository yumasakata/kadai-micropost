class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  def counts(user)
    @count_microposts = user.microposts.count
    @count_followings = user.following_users.count
    @count_followers = user.followers.count
    @count_like_posts = user.like_posts.count
  end
  
   private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end

  end
  
end
