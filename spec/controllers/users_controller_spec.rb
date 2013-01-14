require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'show'" do

    before(:each) do
     #en utilisant le symbole :user on s'assure que Factory Girl devinera que nous voulons utiliser un modèle User, donc dans ce cas @user simulera une instance de la classe User.
      @user = Factory(:user) 
    end

    it "Should success" do
      get :show, :id => @user
      response.should be_success
    end

    it "should trouver le bon utilisateur" do
      get :show, :id => @user # cela revient a faire pareil que get 'show'
      assigns(:user).should == @user # ici (:user) retourne la valeur qu'a la variable d'instance correspondante (ici @user — :user => @user) 
    end


    it "should avoir le bon titre" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.nom)
    end

    it "should inclure le nom de utilisateur" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.nom)
    end

    it "should avoir une image de profil" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar") #qui fait que la balise img est à l'intérieur de la balise h1
    end
  
  end

  describe "GET 'new'" do
   
    it "should be successful" do
      get 'new'
      response.should be_success
    end
	
	it	"it should have good title" do
		get  'new'
		response.should have_selector("title" , :content => "Inscription")
	end

  end




end
