class SessionsController < ApplicationController
 
  def new
  	@titre = "S'identifier"
  end

  def create  
  	user = User.authenticate(params[:session][:email], params[:session][:password])
  	if user.nil?
  		# Crée un message d'erreur et rend le formulaire d'identification.
  		# variable flash est utilisé avant les redirections et persisite sur les autres pages à la différence de flash.now
  		flash.now[:error] = "Combinaison Email/Password invalide." 
  		@titre = "S'identifier"
  		render 'new'
  	else
  		# Authentifie l'utilisateur et redirige vers la page d'affichage.
  		sign_in user
  		redirect_to user
  	end

  end

  def destroy
  	sign_out
  	redirect_to root_path
  end

end
