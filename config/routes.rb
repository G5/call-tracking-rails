Rails.application.routes.draw do
  mount G5Authenticatable::Engine => '/g5_auth'
  mount G5Updatable::Engine => '/g5_updatable'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  post 'call-tracking/forward-call' => 'call_tracking#forward_call', as: :forward_call
  post 'call-tracking/call-end' => 'call_tracking#call_end', as: :end_call
  get 'statistics/leads_by_source' => 'statistics#leads_by_source', as: :leads_by_source
  get 'statistics/leads_by_city' => 'statistics#leads_by_city', as: :leads_by_city

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :lead_sources, only: [:create, :edit, :update]
  resources :available_phone_numbers, only: [:index]

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
