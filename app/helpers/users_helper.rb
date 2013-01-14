module UsersHelper

	def gravatar_for(user, options = { :size => 50 }) #affiche la taille par defaut du gravatar
    	
    	gravatar_image_tag(user.email.downcase, :alt => user.nom,
                                            	:class => 'gravatar',
                                            	:gravatar => options)
  end
end
