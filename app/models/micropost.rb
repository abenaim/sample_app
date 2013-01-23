class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user 

  validates :content , :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true

  # la notion de porté par default l'ordre que l'on desire 
  default_scope :order => 'microposts.created_at DESC'
end
