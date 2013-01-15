class UsersController < ApplicationController
  def new
  	@user = User.new #variable d'instance
  	@titre = "Inscription"
  end

  def show
  	@user = User.find(params[:id])
  	@titre = @user.nom
  end

  def create
  	# Cette ligne est equivalent : @user = User.new(:nom => "Foo Bar", :email => "foo@invalid",:password => "dude", :password_confirmation => "dude")
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Bienvenue dans l'Application Exemple!"
      redirect_to user_path(@user)
    else
      @titre = "Inscription"
      render 'new'
    end
  end
end
