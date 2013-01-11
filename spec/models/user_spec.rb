require 'spec_helper'

describe User do
 
 before(:each) do
 	@attr = {:nom => "Exemple User", :email => "user@example.com"}
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

end
