class UsersController < ApplicationController

  # filtre : fais appel a méthode d'authentification  avant de permettre edit et update , il faut definir aussi la methode deny_access pour que ca fonctionne (session_helper)
  before_filter :authenticate, :only => [:index , :edit, :update, :destroy]
  # filtre : fais appel a méthode correct_ser  
  before_filter :correct_user, :only => [:edit, :update]
  #fitre qui limite l'action destroy qu'au admin
  before_filter :admin_user,   :only => [:destroy, :new]


  def new
  	@user = User.new #variable d'instance
  	@titre = "Inscription"
  end

  def index
    #@users = User.all au lieu de recupere tous les utilisateurs de la base on utilise directement la pagination    
    @users = User.paginate(:page => params[:page])
    @titre = "Tous les utilisateurs"
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:id])
  	@titre = @user.nom
  end

  def create
  	# Cette ligne est equivalent : @user = User.new(:nom => "Foo Bar", :email => "foo@invalid",:password => "dude", :password_confirmation => "dude")
    @user = User.new(params[:user])
    if @user.save
      sign_in @user # une fois apres avoir ajouter l'utilisateur ( le nouveau ) il est logué => il a une session
      flash[:success] = "Bienvenue dans l'Application Exemple!"
      redirect_to user_path(@user)
    else
      @titre = "Inscription"
      render 'new'
    end
  end

  def edit 
    #@user = User.find(params[:id]) plus la peine de le mettre is car dans la fonction correct_user 
    @titre = "Edition Profil"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] ="Profil actualise"
      redirect_to @user
    else
      @titre = "Edition profil"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur supprime."
    redirect_to users_path
  end

  
  private

    # Cette fonction etait initialment ici avant l'utilisation des micropost now elle se trouve dans app/helpers/sessions_helper.rb 
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
