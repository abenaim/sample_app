class User < ActiveRecord::Base
  attr_accessible :email, :nom

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom , :presence => true, :length   => { :maximum => 50 }
  validates :email , :presence => true, 
  					 :format   => { :with => email_regex }, 
  					 # unique est sensible à la casse mais cela ne suffit pas pour eviter les doublons , il faut tout meme creer un idex unique en base sur email
  					 :uniqueness => {:case_sensitive => false } # unique est sensible à la casse
end
