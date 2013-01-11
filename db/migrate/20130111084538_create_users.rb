class CreateUsers < ActiveRecord::Migration
 
 # en lancant la commande rake db:migrate on exécute la méthode self.up et on créer la table
 def self.up
  	# create_table accepte un bloc (section 4.3.2) avec une variable de bloc, dans ce cas appelée t (« t » pour « table »). 
  	# À l'intérieur du bloc, la méthode create_table utilise l'objet t pour créer les colonnes nom et email dans la base de données
    create_table :users do |t|
      t.string :nom
      t.string :email

      t.timestamps
    end
  end

# en lancant la commande rake db:rollback on exécute la méthode self.down : detruit la table users 
# cela est utile dans la mesure on l'on a besoin de rajouter une colonne , pas la peine de faire une nouvelle migration, on peut revenir en arrière ajouter la colone et faire la migration
  def self.down
    drop_table :users
  end

end
