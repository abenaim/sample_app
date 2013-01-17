class ApplicationController < ActionController::Base
  protect_from_forgery

   #Le controller Session est équipé d'un module SessionHelper ( donc pas la peine de généré un nouveau module pour l'authentification)
   #Les fonctions helpers Session sont automatiquement inclus dans les vues Rails, donc il faut juste l'inclure dans le contrôleur Application pour les utiliser 
   #Les fonctions helpers sont accessible aux vues mais pas dans les controllers , il faut donc utiliser les methodes de l'helper aux 2 endroits
 include SessionsHelper
end
