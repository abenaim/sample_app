# Une tâche Rake (.rake) pour peupler la base de données avec des utilisateurs fictifs. 
# pour executer cette tache il suffit d'excuter la commande  rake db:populate
require 'faker'

# il faut preciser le namespace et la tache db:populate
namespace :db do
  desc "Peupler la base de donnees"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    administrateur = User.create!(:nom => "Utilisateur exemple",:email => "example@railstutorial.org", :password => "foobar", :password_confirmation => "foobar")    

    # Peuplement avec un utilisateur administrateur
    administrateur.toggle!(:admin)
    
    # realise task :populate => :environment do 99 fois
    99.times do |n|
      nom  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "motdepasse"
      User.create!(:nom => nom,:email => email, :password => password, :password_confirmation => password)
    end

    # pour les 6 1er user on génère pour chacun d'eux 50 micropost en generant un exemple de contenu grace a Faker::lorem
    User.all(:limit => 6).each do |user|
    	50.times do
    		user.microposts.create!(:content => Faker::Lorem.sentence(5))
    	end
    end
  end
end