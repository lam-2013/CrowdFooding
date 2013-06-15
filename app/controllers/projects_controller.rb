class ProjectsController < ApplicationController
  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def new

    @project = Project.new

    render 'projects/new'
  end

  def index
    @projects = Project.paginate(page: params[:page])
  end

  def create
    # build a new post from the information contained in the "new post" form
    @project = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = 'Project created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'pages/home'
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
