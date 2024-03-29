# Teste les liens du layout ( header , footer)
require 'spec_helper'

describe "LayoutLinks" do

  it "should have a page Accueil at root  " do
    get '/'
    response.should have_selector('title', :content => "Accueil")
  end

  it "should have a page Contact at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have a page About at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a page Help at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a page at root" do
    get '/signup'
    response.should have_selector('title', :content => "Inscription")
  end

  it "should have good click_link on layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Accueil"
    response.should have_selector('title', :content => "Accueil")
    click_link "Inscription"
    response.should have_selector('title', :content => "Inscription")
  end

  describe "quand pas identifie" do
    it "Should avoir un lien de connexion" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => "S'identifier")
    end
  end

  describe "quand identifie" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in "Email",    :with => @user.email
      fill_in "Password", :with => @user.password
      click_button
    end

    it "should avoir un lien de deconnxion" do
      visit root_path
      response.should have_selector("a", :href => signout_path, :content => "Deconnexion")
    end

    it "should avoir un lien vers le profil" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profil")
    end

  end

end
