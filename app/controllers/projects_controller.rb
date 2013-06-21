class ProjectsController < ApplicationController

  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]
  # check if the current user is also an admin
  before_filter :admin_user, only: :destroy

  def new
    @project = Project.new(data_creazione: Time.now, data_fine: Time.now + 2.months)
  end

  def show
    @project = Project.find(params[:id])
    @contributions = @project.contributions.paginate(page: params[:page], per_page: 10)
  end

  def index
    @projects = Project.paginate(page: params[:page], per_page: 10)
  end

  def create
    # build a new project from the information contained in the "new project" form
    @project = current_user.projects.new(params[:project])
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

  private

  def correct_user
    # does the user have a post with the given id?
    @project = current_user.projects.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
  end

end
