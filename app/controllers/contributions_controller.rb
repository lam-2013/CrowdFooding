class ContributionsController < ApplicationController

  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]


  def new

    @contribution = Contribution.new
    @project = Project.find(params[:project_id])

  end

  def index

    @contributions = Contribution.find_all_by_project_id(params[:project_id])
    @project = Project.find(params[:project_id])

  end

  def update
    if @contribution.update_attributes(params[:contribution])
      # handle a successful update
      flash[:success] = 'contributon aggiornato'

      # go to the project
      redirect_to contributions_path(project_id:@project.id)
    else
      # handle a failed update
      render 'edit'
    end
  end



  def edit
    @contribution = Contribution.find_by_id(params[:id])
  end

  def create
    # build a new contribution from the information contained in the "new contribution" form
    @project = Project.find(params[:contribution][:project_id])
    @contribution = @project.contributions.build(params[:contribution])
    if @contribution.save
      flash[:success] = 'Contribution created!'
      redirect_to contributions_path(project_id:@project.id)

    else
      render 'new'
    end

  end

  def destroy
    contribution = Contribution.find(params[:id])
    project = Project.find_by_id(contribution.project_id)
    contribution.destroy

    redirect_to contributions_path(project_id:project.id)

  end

  private

  def correct_user
    # does the user have a post with the given id?
    @contribution = Contribution.find(params[:id])
    @project = current_user.projects.find_by_id(@contribution.project_id)
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
  end
end
