require 'spec_helper'

describe Micropost do
  
  before(:each) do
  	@user = Factory(:user)
  	attr = {:content => "Contenu du message"}
  end

  it "should create une nouvelle instantce avec les attributs valides"
  	@user.microposts.create!(@attr) #créer un micro-message par association avec l'utilisateur
  end

  describe "association avec l utilisateur"
  	
		before(:each) do
	  		@micropost = @user.microposts.create(@attr)
		end

		it "should avoir un attribut user" do
		  @micropost.should respond_to(:user)
		end

		it "should avoir le bon utilisateur associe" do
		  @micropost.user_id.should == @user.id
		  @micropost.user.should == @user
		end  
  end


  describe "validations" do

	    it "should requiert un identifiant d utilisateur" do
	      Micropost.new(@attr).should_not be_valid
	    end

	    it "should requiert un contenu non vide" do
	      @user.microposts.build(:content => "  ").should_not be_valid
	    end

	    it "should rejeter un contenu trop long" do
	      @user.microposts.build(:content => "a" * 141).should_not be_valid
	    end
  end

end
