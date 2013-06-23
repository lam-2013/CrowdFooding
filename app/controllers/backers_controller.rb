class BackersController < ApplicationController

  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:create]


  def create

    @backer = Backer.new(contribution_id:params[:backer][:contribution_id],
                         user_id:params[:backer][:user_id])

    if @backer.save

      update_contribution_number(params[:backer][:contribution_id])
      upadate_project_budget(params[:backer][:project_id],params[:backer][:quota])


      flash[:success] = 'Finanziato!'

      redirect_to project_path(params[:backer][:project_id])

    else
      flash[:error] = 'Non finanziato!'

      redirect_to project_path(params[:backer][:project_id])
    end
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @project = current_user.projects.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
  end

  def update_contribution_number(id)

    contribution = Contribution.find(id)
    contribution.numero -= 1
    contribution.save!

  end

  def upadate_project_budget(id, quota)

    project = Project.find(id)
    project.budget_attuale +=quota.to_f
    project.save!

  end


end
