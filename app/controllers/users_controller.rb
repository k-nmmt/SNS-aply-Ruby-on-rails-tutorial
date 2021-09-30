class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]#直接updateアクションを実行されたらedit画面飛ばして成立してしまうので２つ保護する
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated? #ユーザーが有効化されていなければ表示せずルートへ飛ばす
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save     #すぐにログインする仕様から、メールからの有効化を促しつつトップへ飛ばす仕様に変更済
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted!"
    redirect_to users_url
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated" #成功したときにフラッシュ「Profile updated」表示
      redirect_to @user
    else
      render 'edit'
    end
  end



  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password__confirmation)
  end
  #許可する属性リストにadminは含まれていない

  # beforeアクション

  #正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) #正しいユーザーでなければ、フラッシュもなく問答無用でトップページへ飛ばす
  end

  # 管理者じゃなかったらルートへ飛ばします
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
