class BackersController < ApplicationController

  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:create]


  def create
    session[:return_to] ||= request.referer
    @backer = Backer.new(params[:backer])

    if @backer.save

      flash[:success] = 'Finanziato!'

      redirect_to session[:return_to]

    else
      flash[:error] = 'Non finanziato!'

      redirect_to session[:return_to]
    end
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @project = current_user.projects.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @project.nil?
  end


end
