class PagesController < ApplicationController
  def home

    @user =current_user
    @projects_friends = findProjects_Friends if signed_in?
    @projects_recently = findProjects_recently
    @projects_complete = findProjects_complete
    @projects_in_corso = findProjects_in_corso
    @project = current_user.projects.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page]) if signed_in?
    @numberCAT1= findNumberCAT1    if signed_in?
    @numberCAT2= findNumberCAT2    if signed_in?
    @numberCAT3= findNumberCAT3    if signed_in?
    @numberCAT4= findNumberCAT4     if signed_in?
    @numberCAT5= findNumberCAT5    if signed_in?
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5   if signed_in?

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

    Project.find_by_sql(["SELECT * FROM projects WHERE data_fine > current_timestamp AND user_id IN(SELECT followed_id FROM relationships WHERE follower_id = ?) ORDER BY data_fine",current_user.id])

  end

  def findNumberCAT1

    Project.count_by_sql(["SELECT COUNT (id) FROM projects WHERE user_id = ? AND categoria='ARTE & TEMPO LIBERO' ", @user.id])

  end

  def findNumberCAT2

    Project.count_by_sql(["SELECT COUNT (id) FROM projects WHERE user_id = ? AND categoria='STILE DI VITA & TECNOLOGIA' ", @user.id])

  end

  def findNumberCAT3

    Project.count_by_sql(["SELECT COUNT (id) FROM projects WHERE user_id = ? AND categoria='SOCIAL INNOVATION' ", @user.id])

  end

  def findNumberCAT4

    Project.count_by_sql(["SELECT COUNT (id) FROM projects WHERE user_id = ? AND categoria='EVENTI' ", @user.id])

  end

  def findNumberCAT5

    Project.count_by_sql(["SELECT COUNT (id) FROM projects WHERE user_id = ? AND categoria='CIBO' ", @user.id])

  end


end