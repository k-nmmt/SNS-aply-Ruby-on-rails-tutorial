class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
   # ユーザーのログインを確認する
   def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in." #セッションヘルパーのログドインメソッド。unlessはifの反対
      redirect_to login_url
    end
  end
end
