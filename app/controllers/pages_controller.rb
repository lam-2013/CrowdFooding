class PagesController < ApplicationController
  def home
    @project = current_user.projects.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page]) if signed_in?
  end

  def about
  end

  def contact
  end

  def faq
  end
end
