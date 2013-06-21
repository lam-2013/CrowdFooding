class PagesController < ApplicationController
  def home


    @project = current_user.projects.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page]) if signed_in?

  end

  def about
  end

  def help
  end

  def faq
  end


  def findProjects_in_corso

    projects_in_corso = Project.find_by_sql("SELECT * FROM projects WHERE data_fine > ? AND budget_attuale < goal",Time.now)

    return projects_in_corso
  end
end