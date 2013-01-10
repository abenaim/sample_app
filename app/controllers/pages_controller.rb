 #Dans cette page toutes les variables crées sont accessibles aux vues

class PagesController < ApplicationController
  def home
  	@titre = "Accueil"
  end

  def contact
  	@titre = "Contact"
  end

   def about
   	@titre = "About"
  end

   def help
   	@titre = "Help"
  end
end



