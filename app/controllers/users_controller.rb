class UsersController < ApplicationController
  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]
  # check if the current user is also an admin
  before_filter :admin_user, only: :destroy

  def show
    # get the user with id :id

    @user = User.find(params[:id])


    # get and paginate the posts associated to the specified user
    @projects = @user.projects.paginate(page: params[:page], per_page: 10)
    @projects_progress = findProjects_progress
    @projects_personalComplete = findPersonalProjects_complete
    @projects_personalFinanced = findPersonalProjects_financed
    @projects_personalAll = findPersonalProjects_all
    @somma_progetti_creati_finanziati = somma_progetti_creati_finanziati

    @user_finanziamenti_fatti = user_finanziamenti_fatti
    @somma_quote_denaro_finanziato = somma_quote_denaro_finanziato


    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5

  end

  def new
    auth_hash = request.env['omniauth.auth']

    if params[:provider].nil?
      # init the user variable to be used in the sign up form
      @user = User.new
    else
      # oauth
      if auth_hash.nil? #redirect to the service provider auth page
        redirect_to '/auth/'+params[:provider];
        # twitter is the service provider
      elsif params[:provider]=='twitter'
        @user = User.new(
            twitter_uid: auth_hash[:uid],
            name: auth_hash[:info][:name],
            email: auth_hash[:info][:email])
        # facebook is the service provider
      elsif params[:provider]=='facebook'
        @user = User.new(
            facebook_uid: auth_hash[:credentials][:token],
            name: auth_hash[:info][:first_name],
            email: auth_hash[:info][:email],
            luogo: auth_hash[:info][:location],
            cognome: auth_hash[:info][:last_name],
            sesso: auth_hash[:info][:gender],
            nascita: auth_hash[:info][:birthday],
            descrizione: auth_hash[:info][:bio],
            sito_web: auth_hash[:info][:website])
      end
    end
  end

  def create
    # refine the user variable content with the data passed by the sign up form
    @user = User.new(params[:user])

    if @user.save
      # handle a successful save
      flash[:success] = 'Benvenuto su CrowdFooding!'
      # automatically sign in
      sign_in @user
      redirect_to @user
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
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should also contain:
    # @user = User.find(params[:id])
    # check if the update was successfully
    if @user.update_attributes(params[:user])
      # handle a successful update
      flash[:success] = 'Profilo aggiornato'
      # re-login the user
      sign_in @user
      # go to the user profile
      redirect_to @user
    else
      # handle a failed update
      render 'edit'
    end
  end

  def index
    # get all the users from the database - without pagination
    # @users = User.all
    @user =current_user
    # get all the users from the database - with pagination
    @users = User.paginate(page: params[:page], per_page: 10)
    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5

  end

  def destroy
    # delete the user starting from her id
    User.find(params[:id]).destroy
    flash[:success] = 'Utente cancellato!'
    redirect_to users_url
  end

  # Actions to list the followed users and the followers of a user
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5
    render 'show_follow'

  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @numberCAT1= findNumberCAT1
    @numberCAT2= findNumberCAT2
    @numberCAT3= findNumberCAT3
    @numberCAT4= findNumberCAT4
    @numberCAT5= findNumberCAT5
    @numTotCats=@numberCAT1+@numberCAT2+@numberCAT3+@numberCAT4+@numberCAT5
    render 'show_follow'

  end

  # Paginated search for users
  def search
    @users = User.search(params[:search]).paginate(page: params[:page])
  end

  private

  # Take the current user information (id) and redirect her to the home page if she is not the 'right' user
  def correct_user
    # init the user object to be used in the edit and update actions
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user) # the current_user?(user) method is defined in the SessionsHelper
  end

  # Redirect the user to the home page is she is not an admin (e.g., if the user cannot perform an admin-only operation)
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def findProjects_progress

    Project.find_by_sql(["SELECT * FROM projects WHERE data_fine > current_timestamp AND user_id = ? ORDER BY data_fine",@user.id])

  end

  def findPersonalProjects_complete

    Project.find_by_sql(["SELECT * FROM projects WHERE data_fine < current_timestamp AND user_id = ? AND budget_attuale > goal ORDER BY budget_attuale DESC", @user.id])
  end

  def findPersonalProjects_financed

    Project.find_by_sql(["SELECT * FROM projects WHERE id IN(SELECT project_id FROM backers b, contributions c WHERE b.user_id = ? AND b.contribution_id = c.id) ORDER BY data_fine", @user.id])
  end

  def findPersonalProjects_all

    Project.find_by_sql(["SELECT * FROM projects WHERE user_id = ? ORDER BY data_creazione DESC", @user.id])
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

  def user_finanziamenti_fatti

    Backer.count_by_sql(["SELECT COUNT(*) FROM backers WHERE user_id = ?", @user.id])

  end

  def somma_quote_denaro_finanziato

    Contribution.count_by_sql(["SELECT SUM(quota) FROM contributions WHERE id IN(SELECT contribution_id FROM backers WHERE user_id = ?)",@user.id])

  end

  def somma_progetti_creati_finanziati

    Project.count_by_sql(["SELECT COUNT(*) FROM projects WHERE user_id = ? AND budget_attuale >= goal ",@user.id])

  end

end
