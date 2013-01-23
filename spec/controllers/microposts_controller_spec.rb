require 'spec_helper'

describe MicropostsController do
  render_views

  describe "controle d acces" do

    it "should refuser l acces pour  'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should refuser l acces pour  'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  # --------------------- POST CREATE ------------------------
  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "echec" do

      before(:each) do
        @attr = { :content => "" }
      end

      it "should not creer de micro-message" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should retourner la page d accueil" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end
    end

    describe "succes" do

      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should creer un micro-message" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should rediriger vers la page d accueil" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should avoir un message flash" do
        post :create, :micropost => @attr
        flash[:success].should =~ /created/i
      end
    end
  end

  # ---------------------- DELETE DESTROY --------------------
  describe "DELETE 'destroy'" do

    describe "pour un utilisateur non auteur du message" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should refuser la suppression du message" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "pour l auteur du message" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should detruire le micro-message" do
        lambda do 
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end

end