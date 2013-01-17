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

end
