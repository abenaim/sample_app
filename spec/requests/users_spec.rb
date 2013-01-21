require 'spec_helper'

describe "Users" do
  
	describe "Une inscription" do

	  	describe "fail" do  	
	  		it "should not create un nouvel utilisateur" do
	  			 lambda do
	  			  visit signup_path
		          fill_in "Nom", :with => ""
		          fill_in "Email", :with => ""
		          fill_in "Password", :with => ""
		          fill_in "Confirmation", :with => ""
		          click_button
		          response.should render_template('users/new')
		          response.should have_selector("div#error_explanation")	          
		        end.should_not change(User, :count)
		    end
	  	end

	  	describe "Success" do  	
	  		it "should create a new user" do
	  			lambda do
		          visit signup_path
		          fill_in "Nom", :with => "Example User"
		          fill_in "Email", :with => "user@example.com"
		          fill_in "Password", :with => "foobar"
		          fill_in "Confirmation", :with => "foobar"
		          click_button
		          response.should have_selector("div.flash.success", :content => "Bienvenue")
		          response.should render_template('users/show')
		        end.should change(User, :count).by(1)
	  		end
	  	end  	
	end

	describe "identification/deconnexion" do

		describe "Fail" do
		  
			it "should not identifier l utilisateur" do
			    visit signin_path
			    fill_in "Email",    :with => ""
			    fill_in "Password", :with => ""
			    click_button
			    response.should have_selector("div.flash.error", :content => "invalide")
		  	end
		end

		describe "le succes" do
		  
			it "Should identifier un utilisateur puis le deconnecter" do
			    user = Factory(:user)
			    # fonction definit dans sec_helper.rb
			    integration_sign_in(user)
			    controller.should be_signed_in
			    #l'utilisation de click_link "Déconnexion", qui ne fait pas que simuler le clic sur le lien de déconnexion dans le navigateur 
			    # mais produit également une erreur si ce lien n'existe pas
			    click_link "Deconnexion"
			    controller.should_not be_signed_in  # equivaut à controller.signed_in?.should be_true
			end
		end
	end

	describe "Attribut admin" do

	    before(:each) do
	      @user = User.create!(@attr)
	    end

	    it "should confirmer l existence de `admin`" do
	      @user.should respond_to(:admin)
	    end

	    it "should not etre un administrateur par defaut" do
	      @user.should_not be_admin
	    end

	    it "should pouvoir devenir un administrateur" do
	      @user.toggle!(:admin) #toggle! (bascule !) pour basculer la valeur de l'attribut admin de false (faux) à true
	      @user.should be_admin # cettte ligne implique que l'utilisateur devrait posseder une methode boolenne admin?
	    end
	end

end

	
