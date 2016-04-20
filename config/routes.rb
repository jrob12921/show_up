Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'artist_events/:id' => "search#artist_events", as: "artist_events"
  get 'venue_events/:id' => "search#venue_events", as: "venue_events"
  get 'local_events' => "search#local_events", as: "local_events"
  get 'results' => "search#results", as: 'results'

  resources :events do 
    resources :group_messages
    resources :direct_messages
  end
  resources :user_events

  get 'user_history/:sender_id/:recipient_id' => "direct_messages#user_history", as: 'user_history'

  get 'event_dm/:event_id/:sender_id/:recipient_id' => "direct_messages#event_dm", as: 'event_dm'

  get 'my_chats/:id' => "direct_messages#my_chats", as: 'my_chats'


  get 'my_events/:id' => "user_events#my_events", as: 'my_events'

  get 'event/:id/users' => "events#event_users", as: "event_users"

  post 'attend/:id' => "user_events#attend", as: "attend"
  post 'unattend/:id' => "user_events#unattend", as: "unattend"
  
  # You can have the root of your site routed with "root"
  root 'search#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
