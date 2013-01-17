require 'spec_helper'

describe SessionsController do
	render_views

 # -------------------------------------- GET NEW ------------------------------


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

     it "should have le bon titre" do
      get 'new'
      response.should have_selector("titre", :content => "S'identifier")
    end
  end

 # -------------------------------------- POST CREATE ------------------------------

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-rendre la page new" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should avoir le bon titre" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "S'identifier")
      end

      it "should avoir un message flash.now" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "should have un email et un mot de passe valides" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should identifier l'utilisateur" do
        post :create, :session => @attr
        # Remplir avec les tests pour l'identification de l'utilisateur.
        # la variable controller est accessible a l'interieur des test
        controller.current_user.should == @user
        # equivaut à controller.signed_in?.should be_true
        controller.should be_signed_in 
      end

      it "should rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end

  end

 # -------------------------------------- POST DELETE ------------------------------
  
  describe "DELETE 'destroy'" do

    it "should deconnecter un utilisateur" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
