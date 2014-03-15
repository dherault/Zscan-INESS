Zscan::Application.routes.draw do

  resources :stocks

  resources :specials

  resources :orders

  resources :users

  resources :cards

  resources :products

  resources :shops

  get "pages/home"
  get "pages/admin_panel"
  get "shops/:id/products", to: "shops#view_products", as: :view_products
  post "shops/:id/products/add/:product_id", to: "shops#add_product"
  post "shops/:id/products/remove/:product_id", to: "shops#remove_product"
  get "products/:id/shops", to: "products#view_shops", as: :view_shops_for_product
  post "products/:id/shops/add/:shop_id", to: "products#add_shop"
  post "products/:id/shops/remove/:shop_id", to: "products#remove_shop"
  get "login", to: "shops#before_login", as: :before_login
  post "shops/login", to: "shops#login", as: :login
  post "shops/logout", to: "shops#logout", as: :logout
  get "assign_cards", to: "cards#before_assign", as: :before_assign_cards
  post "assign_cards_do", to: "cards#assign", as: :assign_cards
  get "checkout", to: "pages#checkout", as: :checkout
  get "SDT", to: "pages#checkout_sdt", as: :checkout_sdt
  post "users/get_by_card", to: "users#get_by_card", as: :get_user_by_card
  post "save_checkout", to: "orders#save_checkout", as: :save_checkout
  post "save_checkout-sdt", to: "orders#save_checkout_sdt", as: :save_checkout_sdt
  get "saloon", to: "pages#saloon", as: :saloon
  get "shops/:id/specials", to: "shops#view_specials", as: :view_specials
  post "shops/:id/specials/add/:special_id", to: "shops#add_special"
  post "shops/:id/specials/remove/:special_id", to: "shops#remove_special"
  get "specials/:id/shops", to: "specials#view_shops", as: :view_shops_for_special
  post "specials/:id/shops/add/:shop_id", to: "specials#add_shop"
  post "specials/:id/shops/remove/:shop_id", to: "specials#remove_shop"
  get "read_cards", to: "cards#before_read", as: :before_read_cards
  post "read_cards_do", to: "cards#read", as: :read_cards
  post "cancel_order", to: "orders#cancel_order", as: :cancel_order
  post "transfer", to: "cards#transfer", as: :transfer
  post "save_saloon", to: "orders#save_saloon", as: :save_saloon
  get "stats", to: "pages#stats", as: :stats
  get "gripss", to: "pages#simple_stats", as: :simple_stats
  get "socks_dashboard", to: "stocks#dashboard", as: :stocks_dashboard
  post "add_stock", to: "stocks#add_stock", as: :add_stock
  get "handlewsold/:channel", to: "messages#handle"
  get "handlews/:channel/:shop", to: "messages#handle_redis"
  get "chatter", to: "messages#chatter", as: :chatter
  get "JOUJOUxxx111", to: "shops#quick_start"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#home'

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
