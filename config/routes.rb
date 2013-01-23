SampleApp::Application.routes.draw do  

  #De cette facon on permet toutes les ecriture que connait l'architecture REST (/users, users/new, users/1 ...)
 resources :users  # avant il y avait ceci   get "users/new"
 resources :sessions, :only => [:new, :create, :destroy] #ce sont les actions que l'on va avoir pour ce controller
 resources :microposts , :only => [:create, :destroy]
   

  #’/about’ et le route vers l'action about du contrôleur Pages 
  # Avant, c'était plus explicite : nous utilisions get ’pages/about’ pour atteindre le même endroit, mais /about est plus succint
  # De cette maniere dans les vues il suffit d'utiliser about_path => '/about' ,about_url  => 'http://localhost:3000/about'
  #
   match '/contact', :to => 'pages#contact' # on fait appel à l'action contact du controller pages avec ceci match  '/contact'
   match '/about',   :to => 'pages#about'
   match '/help',    :to => 'pages#help'
   match '/signup',  :to => 'users#new'
   match '/signin',  :to => 'sessions#new'
   match '/signout', :to => 'sessions#destroy'

  #  Premier exemple de routes
  get "pages/home"
  # get "pages/contact"
  # get "pages/about"
  # get "pages/help"
  # get "sessions/new" Cette ligne est généré automatiquement lorsque l'on genere le controller, elle est remplacé par les ressources


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
