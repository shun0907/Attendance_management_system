class UsersController < ApplicationController
  require 'date'
  require 'time'
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :is_admin,   only: [:index, :edit, :show, :attendance_edit, :besic_info]
  

  def index
    is_admin
    
    logger.debug('is_admin ========================')
    logger.debug(@is_admin)
      
    @users = User.all.paginate(page: params[:page])
  end
  
  def show
    is_admin
    @today = Date.today.strftime('%Y年%-m月')
    @user = User.find(params[:id])
    @total_time = 0
    
    @list_months, @query, @target_date, @end_day, @total_days, @today = Shift.shift_list(params)
  end
  
  # def clock_in
  #   user_id = params[:user_id]
  #   clock_in = Time.now.in_time_zone('Tokyo')
  #   shift = Shift.new(user_id: user_id, date: clock_in.strftime('%Y-%m-%d'), start_time: clock_in.strftime('%H:%M:%S'))
    
  #   shift.save
    
  #   user = User.find(user_id)
  #   redirect_to(user)
  # end
  
  def clock_in
    user_id = params[:user_id]
    clock_in = Time.now.in_time_zone('Tokyo')
    shift = Shift.where(user_id: user_id, date: clock_in.strftime('%Y-%m-%d'))
    
    shift.update(start_time: clock_in.strftime('%H:%M'))
    
    user = User.find(user_id)
    redirect_to(user)
  end
  
  def clock_out
    user_id = params[:user_id]
    clock_out = Time.now.in_time_zone('Tokyo')
    shift = Shift.where(user_id: user_id, date: clock_out.strftime('%Y-%m-%d'))
    
    shift.update(end_time: clock_out.strftime('%H:%M'))
    
    user = User.find(user_id)
    redirect_to(user)
  end
  
  def attendance_edit
    @attendance_edit = '勤怠編集ページ'
    
    @wday = [ "日", "月", "火", "水", "木", "金", "土" ]
    @query = params[:q].nil? ? "0" : params[:q];
    today = Time.zone.now.in_time_zone('Tokyo').strftime('%Y-%m-%d')
    @target_date = today.to_date.months_since(@query.to_i)
    start_day = @target_date.beginning_of_month.strftime('%Y-%m-%d')
    end_day = @target_date.end_of_month.strftime('%Y-%m-%d')
    
    @user = User.find(params[:id])
    @shift = Shift.where(user_id: params[:id], date: start_day..end_day).order(:date)
  end
  
  def attendance_save
    is_success = true
    
    shift_params.each do |id, param|
      shift = Shift.find(id)
      
      today = Time.zone.now.in_time_zone('Tokyo').strftime('%Y-%m-%d')

      if param['start_time'].present? || param['end_time'].present?
        if param['end_time'].present? && param['start_time'] > param['end_time']
          is_success = false
          next
        end
        
        if shift.date.to_date > today.to_date
          is_success = false
          next
        end
      
        shift.update_attributes(param)
      end
    end
    
    if is_success
      flash[:success] = '勤怠時間を更新しました。'
      action = 'show'
    else
      flash[:warning] = '未来の勤怠編集および出社時間より退社時間が早い勤怠編集は出来ません。'
      action = 'attendance_edit'
    end

    redirect_to controller: 'users', action: action, id: params[:user][:user_id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成が完了しました'
      redirect_to @user
      # @user.send_activation_email
      # flash[:info] = "Please check your email to activate your account."
      # redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報の更新が完了しました'
      
      if params[:user][:from] === 'i'
        redirect_to action: 'index'
      else
        redirect_to @user
      end
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました'
    redirect_to users_url
  end
  
  def besic_info
    @from = params[:from]
    @user = User.find(params[:id])
    @hour_list = []
    1.step(24, 0.5).map { |m| 
      @hour_list.push([m]) 
    }
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(
        :id,
        :name,
        :email,
        :affiliation,
        :designation_work_hours,
        :besic_work_hours,
        :password,
        :password_confirmation
      )
    end
    
    def shift_params
      params.permit(shifts: [:user_id, :start_time, :end_time])[:shifts]
    end

    # beforeアクション
    
    # 正��いユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      # redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end