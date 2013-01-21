module SessionsHelper
	
	def sign_in(user)
		# la session : Une technique pour maintenir l'état de l'identification de l'utilisateur afin de le pister
		# la session contient user.id (ou remember_token) : session[:remember_token] = user.id
		# on place dans un cookies (qui expire a la fermeture du navigateur) la session, afin de securisé au maximum on rajoute le salt
		# cookies est une table et chaque element est lui meme une table de 2 elements (valeur et date)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		#cette variable sera accessibl dans les controlleur et dans les vues
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

    #appelle la méthode user_from_remember_token la 1er fois que current_user est appelé, mais retourne @current_user au cours des invocations suivantes sans appeler user_from_remember_token.
	def current_user
		@current_user ||= user_from_remember_token # Ceci || = veut dire ou égale
	end

 	def signed_in?
		!current_user.nil?
	end

	def sign_out
    	cookies.delete(:remember_token)
    	self.current_user = nil
  	end

	# fonction utiliser dans user_controller avec les filtres
  	def current_user?(user)
    	user == current_user
    end

  	# fonction utiliser dans user_controller avec les filtres
  	def deny_access
    	redirect_to signin_path, :notice => "Merci de vous identifier pour rejoindre cette page." #equivaut à flash[:notice] = "Merci de vous identifier pour rejoindre cette page."
  	end

  	# on redirige soit vers la requete URL ( request.fullpath) si elle est rempli sinon on prend celle par defaut
  	def redirect_back_or(default)
    	redirect_to(session[:return_to] || default)
    	clear_return_to
  	end

	private

		def user_from_remember_token
			# l'opérateur *, qui nous permet d'utiliser un tableau à deux éléments comme argument pour une méthode attendant deux variables (id et salt)
			# fonction definit dans app/models/user.rb
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			#ici on dit retourner un tableau de valeurs nulles si cookies.signed[:remember_me] lui-même est nul 
			cookies.signed[:remember_token] || [nil, nil]
		end

		def store_location
      		session[:return_to] = request.fullpath
    	end

    	def clear_return_to
      		session[:return_to] = nil
    	end


end
