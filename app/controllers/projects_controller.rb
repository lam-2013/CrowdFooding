class ProjectsController < ApplicationController
  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :show]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]
  # check if the current user is also an admin
  before_filter :admin_user, only: :destroy


  def new
    @project = Project.new(data_creazione: Time.now, data_fine: Time.now + 4.weeks)
    @user=current_user
    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5

  end

  def show
    @backer_numbers = count_backer(params[:id])
    @project = Project.find(params[:id])
    @contributions = @project.contributions
    @backer = Backer.new
    @username = @project.user.name
    @user = @project.user


  end

  def index
    @projects_friends = findProjects_Friends if signed_in?
    @projects_recently = findProjects_recently
    @projects_complete = findProjects_complete
    @projects_in_corso = findProjects_in_corso
    @user = current_user
    @projects = Project.paginate(page: params[:page], per_page: 10)
    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5

  end

  def create
    # build a new project from the information contained in the "new project" form
    @project = current_user.projects.new(params[:project])
    @project.budget_attuale=0
    @project.save

    if @project.save
      flash[:success] = 'Project created!'
      redirect_to @project
    else
      render 'new'
    end
  end

  def edit
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should contain:
    # @user = User.find(params[:id])
  end

  def update

    @id_project= @project.id

    if @project.update_attributes(params[:project])
      # handle a successful update
      flash[:success] = 'Project aggiornato'

      # go to the project
      redirect_to @project
    else
      # handle a failed update
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to current_user
  end

  def search_projects
    @projects = Project.search(params[:search]).paginate(page: params[:page])
  end

  def count_backer(id)
    Backer.count_by_sql(["SELECT COUNT(DISTINCT user_id) FROM backers b, contributions c WHERE b.contribution_id = c.id AND c.project_id = ?",id])
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @project = current_user.projects.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
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
