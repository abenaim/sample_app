# Identification et redirection vers les pages voulues : si un utilisateur non identifié essaie de visiter sa page d'édition, après s'être identifié, 
# il sera redirigé vers /users/1 (l'affichage de son profil) au lieu de /users/1/edit (sa page d'édition).
require 'spec_helper'

describe "FriendlyFowardings" do
   
    it "should rediriger vers la page voulue apres identification" do
	    user = Factory(:user)
	    visit edit_user_path(user)
	    # Le test suit automatiquement la redirection vers la page d'identification.
	    fill_in :email,    :with => user.email
	    fill_in :password, :with => user.password
	    click_button
	    # Le test suit à nouveau la redirection, cette fois vers users/edit.
	    response.should render_template('users/edit')
 	end
end
