# En utilisant le symbole ':user', nous faisons que Factory Girl simule un modèle User.
Factory.define :user do |user|
  user.nom                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

# consite a généré des email users d'usines de type person-1@example.com, person-2@example.com a utiliser dans user_controller
Factory.sequence :email do |n|
	"person-#{n}example.com"
end

#consiste à générer des micropost d'usines associé aux users d'ou le micropost.association user
Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end

