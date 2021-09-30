class StaticPagesController < ApplicationController
  def home
    if logged_in? #ログインしているなら
    @micropost = current_user.microposts.build #現在のユーザーのマイクロポストを作る
    @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
