class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user.present?
      if user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:success] = 'ログインしました'
        redirect_back_or user
      else
        flash.now[:danger] = 'メールアドレスとパスワードが一致しません'
        render 'new'
      end
    else
      flash.now[:danger] = 'このメールアドレスを使用しているユーザーは存在しません'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    @_current_user = session[:user_id] = nil
    redirect_to root_url
  end
end