class ProjectsController < ApplicationController
  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def new

    @project = Project.new(data_creazione: Time.now, data_fine: Time.now + 2.months)
    @cat=["ART & ENTERTAINMENT","LIFESTYLE & TECHNOLOGY","SOCIAL INNOVATION","EVENTI","FOOD"]

  end

  def show
      @project = Project.find(params[:id])
      #@contributions = @project.contributions.paginate(page: params[:page], per_page: 10)
  end

  def index
    @projects = Project.paginate(page: params[:page], per_page: 10)
  end

  def show
    # get the project with id :id
    @project = Project.find(params[:id])

    # get and paginate the contributions associated to the specified projects
    #@contributions = @project.contributions.paginate(page: params[:page], per_page: 10)

  end

  def create
    # build a new project from the information contained in the "new project" form
    @project = Project.new(params[:project])
    if @project.save
      flash[:success] = 'Project created!'
      redirect_to @project
    else
      render 'new'
    end
  end

  def update
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
