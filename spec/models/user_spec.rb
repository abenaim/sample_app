require 'spec_helper'

describe User do
 
 before(:each) do
 	@attr = {:nom => "Exemple User", :email => "user@example.com", :password => "foobar" , :password_confirmation => "foobar"}
 end

 it "should create a new instance with validate attributes" do
 	User.create!(@attr)
 end

 it "Should have a name" do
    #merge pour créer un nouvel utilisateur appelée bad_guy avec un nom vierge
    bad_guy = User.new(@attr.merge(:nom => ""))
    bad_guy.should_not be_valid
  end

 it "should have an email" do
 	no_email_user = User.new(@attr.merge(:email=>""))
 	no_email_user.should_not be_valid
 end

 it "should  reject name too long" do
    long_nom = "a" * 51
    long_nom_user = User.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end

  it "Should accept an adress email valide" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject an adress email invalide" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "Should reject an email double" do
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject an adress email invalide avec la casse" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

# ----------------------------- password validations -------------------------

 describe "password validations" do

    it "should have a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should have the same password and confirmation password" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject password too long" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

 #----------------------------- password encryption -------------------------

describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an attribut password crypter" do
      #@user.should respond_to(:encrypted_password)
      @user.encrypted_password.should_not be_blank
    end

	it "should return true si les mots de passe coincident" do
   	 	@user.has_password?(@attr[:password]).should be_true
 	end    

  	it "should return false si les mots de passe divergent" do
    	@user.has_password?("invalide").should be_false
  	end 


  	describe "authenticate method" do

      it "should retourner nul en cas de inequation entre email  et mot de passe" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should retourner nil quand un email ne correspond a aucun utilisateur" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should retourner un utilisateur si email/mot de passe correspondent" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  

  end

end
