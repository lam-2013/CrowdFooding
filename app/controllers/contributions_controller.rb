class ContributionsController < ApplicationController

  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]
  # check if the current user is also an admin
  before_filter :admin_user, only: :destroy

  def new

    @contribution = Contribution.new

  end

  def index
    @contributions = Contribution.find_all_by_project_id(params[:project_id])
  end

  def update
    if @contribution.update_attributes(params[:contribution])
      # handle a successful update
      flash[:success] = 'contributon aggiornato'

      # go to the project
      redirect_to @contribution
    else
      # handle a failed update
      render 'edit'
    end
  end



  def edit
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should contain:
    # @contribution = Contribution.find(params[:id])
  end

  def create
    # build a new contribution from the information contained in the "new contribution" form
    @project = current_user.projects.new(params[:project])
    @contribution =@project.contributions.build(params[:contribution])
    if @contribution.save
      flash[:success] = 'Contribution created!'
      redirect_to root_url
    end

  end

  def destroy
    @contribution.destroy
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @project = current_user.projects.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
  end
end
