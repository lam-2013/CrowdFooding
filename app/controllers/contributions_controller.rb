class ContributionsController < ApplicationController

  def index
    @contributions = Contribution.paginate(page: params[:page])
  end

  def show
    @projects = Project.find(params[:id])
    @contribution = @projects.contributions.paginate(page: params[:page], per_page: 10)
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

  def new

    @contribution = Contribution.new

  end

  def edit
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should contain:
    # @user = User.find(params[:id])
  end

  def create
    # build a new contribution from the information contained in the "new contribution" form

    @contribution = current_user.projects.contributions.build(params[:contribution])
    if @contribution.save
      flash[:success] = 'Contribution created!'
      redirect_to root_url
    end

  end

  def destroy
    @contribution.destroy
  end
end
