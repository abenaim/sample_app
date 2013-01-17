require 'spec_helper'

describe UsersController do
	render_views

# -------------------------------------- GET SHOW ------------------------------

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

# -------------------------------------- GET NEW ------------------------------

  describe "GET 'new'" do
   
    it "should be successful" do
      get 'new'
      response.should be_success
    end
	
	it	"it should have good title" do
		get  'new'
		response.should have_selector("title" , :content => "Inscription")
	end

	it "should have a field nom"
		get 'new'
		response.should have_selector("input[nom='user[nom]'][type='text']")
	end

	it "should have a field email"
		get 'new'
		response.should have_selector("input[email='user[email]'][type='text']")
	end

	it "should have a field password"
		get 'new'
		response.should have_selector("input[password='user[password]'][type='password']")
	end

	it "should have a field password_confirmation"
		get 'new'
		response.should have_selector("input[password_confirmation='user[password_confirmation]'][type='password']")
	end

  end


# -------------------------------------- POST CREATE ------------------------------

describe "POST 'create'" do

    describe "Failed" do

      before(:each) do
        @attr = { :nom => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count) #change : retourne le changement du nombre d'utilisateurs dans la base de données :
      end

      it "it should have good title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Inscription")
      end

      it "should get page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  

  	describe "success" do

        before(:each) do
          @attr = { :nom => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
        end

        it "should create new user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1) # on attend du bloc lamda qu'il change le compte User de 1
        end

        it "should redirect_to view page user " do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end 

        it "should have a message of welcome" do
          post :create, :user => @attr
          flash[:success].should =~ /Bienvenue dans l'Application Exemple/i #permet de faire une comparaison sans etre sensible à la casse
        end 

        it "should identifier l utilisateur" do
          post :create, :user => @attr
          controller.should be_signed_in
      end  
    end


  end


end
