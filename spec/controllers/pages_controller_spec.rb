# Page qui execute tous les tests pour le controller Pages : commande a exécuter : bundle exec rspec/spec
require 'spec_helper'

describe PagesController do
  render_views

  #Avant d'exécuter toutes les test on lance ce code
  before(:each) do
    @base_title = "Simple App du Tutoriel Ruby on Rails |"
  end


  describe "GET 'home'" do

    #permet de tester l'existance de la page
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    #permet de tester la validité du title de chaque page
     it "should have good title " do 
      get 'home'
      response.should have_selector("title", :content => @base_title + " Accueil")
    end

    it "should"
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have good title " do
      get 'contact'
      response.should have_selector("title", :content => @base_title + " Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

     it "should have good title " do
      get 'about'
      response.should have_selector("title", :content => @base_title + " About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

     it "should have good title " do
      get 'help'
      response.should have_selector("title", :content => @base_title + " Help")
    end
  end

end
