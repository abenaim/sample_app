 #Dans cette page toutes les variables crées sont accessibles aux vues

class PagesController < ApplicationController
  def home
  	@titre = "Accueil"
    if signed_in?
      @micropost = Micropost.new  
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
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



