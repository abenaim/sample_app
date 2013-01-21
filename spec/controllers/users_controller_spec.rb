require 'spec_helper'

describe UsersController do
	render_views

  # -------------------------------------- GET INDEX -----------------------------
    describe "GET 'index'" do

      describe "pour utilisateur non identifies" do

        it "should refuser l acces" do
          get :index
          response.should redirect_to(signin_path)
          flash[:notice].should =~ /identifier/i
        end
      end

      # on creer 3 utilisateur d'usine et oon verifie que la pge d'index a une liste contenant des li pour le nom de chacun d'eux
      describe "pour un utilisateur identifie" do

        before(:each) do        
          @user = test_sign_in(Factory(:user))
          second = Factory(:user,  :email => "another@example.com")
          third  = Factory(:user,  :email => "another@example.net")

          @users = [@user, second, third]

          # voir dans factory genere 31 users et les rentres push << dans le tableau users
          30.times do
            @users << Factory(:user, :email => Factory.next(:email))
          end
        end

        it "should reussir" do
          get :index
          response.should be_success
        end

        it "should avoir le bon titre" do
          get :index
          response.should have_selector("title", :content => "Liste des utilisateurs")
        end

        it "should avoir un element pour chaque utilisateur" do
          get :index
          @users.each do |user|
            response.should have_selector("li", :content => user.nom)
          end
        end

        it "should avoir un element pour chaque utilisateur" do
          get :index
          @users[0..2].each do |user|
            response.should have_selector("li", :content => user.nom)
          end
        end

        it "should paginer les utilisateurs" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector("a", :href => "/users?page=2",  :content => "2")
          response.should have_selector("a", :href => "/users?page=2",  :content => "Next")
        end
      end
    end

  # ----------------- AUTHENTIFICATION DES PAGES EDIT / UPDATE--------------------
    describe "authentification des pages edit/update" do

      before(:each) do
        @user = Factory(:user)
      end

      describe "pour un utilisateur non identifie" do

        it "should refuser l accces a l action 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end

        it "should refuser  l accces a l action 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end

      describe "pour un utilisateur identifie" do

        before(:each) do
          wrong_user = Factory(:user, :email => "user@example.net")
          test_sign_in(wrong_user)
        end

        it "should correspondre a l utilisateur a editer" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should correspondre a l utilisateur a actualiser" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end
    end

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

  # -------------------------------------- GET EDIT ------------------------------
    describe "GET 'edit'" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should success" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should avoir le bon titre" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edition Profil")
      end

      it "should avoir un lien pour changer l image Gravatar" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_selector("a", :href => gravatar_url, :content => "changer")
      end
    end

  # -------------------------------------- POST CREATE ---------------------------

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

  # -------------------------------------- PUT UPDATE ----------------------------
    
    describe "PUT 'update' " do

      before(:each) do
        @user =Factory(:user)
        test_sign_in(@user)    
      end

      describe "Echec" do

        before(:each) do
          @attr = { :email => "", :nom => "", :password => "", :password_confirmation => "" }
        end

        it "Should retourner la page d edition" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should avoir le bon titre" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edition profil")
        end      
      end

      describe "Success" do

        before(:each) do
          @attr = { :nom => "New Name", :email => "user@example.org",:password => "barbaz", :password_confirmation => "barbaz" }
        end

        it "should modifier les caracteristiques de l utilisateur" do
          put :update, :id => @user, :user => @attr
          #Ce code recharge la variable @user de la base de données (de test) en utilisant @user.reload, et vérifie alors que le nouveau nom de l'utilisateur et son adresse mail correspondent aux valeurs de la table @attr
          @user.reload
          @user.nom.should  == @attr[:nom]
          @user.email.should == @attr[:email]
        end

        it "should rediriger vers la page d affichage de l utilisateur" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should afficher un message flash" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /actualise/
        end      
      end    
    end   

  # -------------------------------------- GET NEW  ------------------------------

    describe "GET 'new'" do
     
      it "should be successful" do
        get 'new'
        response.should be_success
      end
    
      it  "should have good title" do
        get  'new'
        response.should have_selector("title" , :content => "Inscription")
      end

      it "should have a field nom" do
        get 'new'
        response.should have_selector("input[name='user[nom]'][type='text']")
      end

      it "should have a field email" do
        get 'new'
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a field password" do
        get 'new'
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a field password_confirmation" do
        get 'new'
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
    end

  # -------------------------------------- DELETE   ------------------------------
    describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "en tant qu utilisateur non identifie" do
      it "should refuser l acces" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "en tant qu utilisateur non administrateur" do
      it "should proteger la page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "en tant qu'administrateur" do

      before(:each) do
        # bien que admin ne soit pas dans attr_accessible on peut faire :admin car les user d'usines ne se sont pas concerné par cette regle
        admin = Factory(:user, :email => "admin@example.com", :admin => true) 
        test_sign_in(admin)
      end

      it "should detruire l utilisateur" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should rediriger vers la page des utilisateurs" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
    end

end


