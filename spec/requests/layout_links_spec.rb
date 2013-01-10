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

end
