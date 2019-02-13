class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def is_admin
      @login_user = session[:user_id] ? User.find(session[:user_id]) : nil;
      @is_admin = @login_user.admin.present? ? @login_user.admin : nil;
  end

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
end