require 'digest'  #librairie utiliser pour le hachage cryptographique SHA2
class User < ActiveRecord::Base
  #nous n'allons enregistrer qu'un mot de passe crypté dans la base de données ; pour le mot de passe, 
  #nous allons introduire la notion d'attribut virtuel (cad un attribut qui ne correspond pas à une colonne de la base de données) en utilisant la méthode attr_accessor
  attr_accessor :password
  
  #cela nom permet d'utiliser les colonnes dans les autres pages  (donc on evite de mettre :admin pour que personne est la possibilite de mofier cette var)
  attr_accessible :email, :nom, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom , :presence => true, :length   => { :maximum => 50 }
  validates :email , :presence => true, 
  					 :format   => { :with => email_regex }, 
  					 # unique est sensible à la casse mais cela ne suffit pas pour eviter les doublons , il faut tout meme creer un idex unique en base sur email
  					 :uniqueness => {:case_sensitive => false } # unique est sensible à la casse


#permet de créer virtuellement un attribut password_confirmation (il n'est pas en base) qui corespond a l'attribut password
  validates :password, 
  			:presence => true,  
  			:confirmation => true, #rejette les utilisateurs dont le mot de passe et sa confirmation ne correspondent pas
  			:length => {:within => 6..40}


#Avant d'enregistre le user on encrype le passeword
before_save :encrypt_password

# Retour true (vrai) si le mot de passe correspond ( entre celui de la base et celui saisi). Methode publique donc accessible pour les test
  def has_password?(password_soumis)
    # Compare encrypted_password avec la version cryptée de password_soumis.
    encrypted_password == encrypt(password_soumis)
  end

 # ici le SELF.auth permet de dire que auhenticate est une méthode de la classe User , on peut remplacer self par User.
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    # le ? s'appelle un operateur ternaire
    (user && user.salt == cookie_salt) ? user : nil # equivaut à return nil  if user.nil?   return user if user.salt == cookie_salt
  end

#Correspond à des fonctions de rappel : user.encrypt_password ceci ne fonctionne pas car on est dans la section private
private
	def encrypt_password
		self.salt = make_salt if new_record?      # en incluant new_record? nous nous assurons que le salt sera créé seulement une fois, à la création de l'utilisateur
		self.encrypted_password = encrypt(password) # le self ici est obligatoire , il recupere l'objet courant , le 2émé self est facultatif et implicite (self.password)
	end

	def  encrypt(string)
		#nous avons haché le sel ( Time.now.utc) eavec le mot de passe, pour retourner un mot de passe crypté qu'il est virtuellement impossible de cracker 
		secure_hash("#{salt}--#{string}") #(pour la clarté, les arguments des fonctions de hachage sont souvent séparés par des « -- »).
	end

	 def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
