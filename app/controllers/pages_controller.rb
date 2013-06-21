class PagesController < ApplicationController
  def home

    @projects_friends = findProjects_Friends
    @projects_recently = findProjects_recently
    @projects_complete = findProjects_complete
    @projects_in_corso = findProjects_in_corso
    @project = current_user.projects.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page]) if signed_in?

  end

  def about
  end

  def help
  end

  def findProjects_complete

    Project.find_by_sql("SELECT * FROM projects WHERE data_fine < current_timestamp AND budget_attuale > goal ORDER BY budget_attuale DESC")

  end

  def findProjects_in_corso

    Project.find_by_sql("SELECT * FROM projects WHERE data_fine > current_timestamp AND budget_attuale > goal ORDER BY data_creazione")

  end

  def findProjects_recently

    Project.find_by_sql("SELECT * FROM projects WHERE data_fine >= current_timestamp AND budget_attuale < goal ORDER BY data_creazione DESC LIMIT 10")

  end

  def findProjects_Friends

    puts current_user.id
    Project.find_by_sql(["SELECT * FROM projects WHERE user_id IN(SELECT followed_id FROM relationships WHERE follower_id = ?)",current_user.id])

  end
end