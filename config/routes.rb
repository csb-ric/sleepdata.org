WwwSleepdataOrg::Application.routes.draw do

  resources :agreements do
    member do
      get :download
      get :review
    end
  end

  resources :datasets do
    member do
      get :sync
      get :logo
      get :audits
      get :request_access
      get :requests
      post :create_access
      patch :set_access
      get "(/a/:auth_token)/manifest(/*path)", action: 'manifest', as: :manifest, format: false
      get "files((/a/:auth_token)(/m/:medium)/*path)", action: 'files', as: :files, format: false
      get "search", action: 'search', as: :search

      get "images/*path", action: 'images', as: :images, format: false
      get "pages(/*path)", action: 'pages', as: :pages, format: false
      get "edit_page/*path", action: 'edit_page', as: :edit_page, format: false
      get "new_page(/*path)", action: 'new_page', as: :new_page, format: false
      post "create_page(/*path)", action: 'create_page', as: :create_page, format: false
      patch "update_page/*path", action: 'update_page', as: :update_page, format: false
      post :pull_changes

    end

    resources :variables do
      member do
        get :image
      end
    end
  end

  resources :tools do
    member do
      get :sync
      get :logo

      get :requests
      get :request_access
      post :create_access
      patch :set_access

      get "images/*path", action: 'images', as: :images, format: false
      get "pages(/*path)", action: 'pages', as: :pages, format: false
      get "edit_page/*path", action: 'edit_page', as: :edit_page, format: false
      get "new_page(/*path)", action: 'new_page', as: :new_page, format: false
      post "create_page(/*path)", action: 'create_page', as: :create_page, format: false
      patch "update_page/*path", action: 'update_page', as: :update_page, format: false
      post :pull_changes
    end
  end

  devise_for :users, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords', confirmations: 'contour/confirmations', unlocks: 'contour/unlocks' }, path_names: { sign_up: 'register', sign_in: 'login' }

  resources :users

  # get '/rdi3p' => 'welcome#rdi3p', as: :rdi3p
  get 'welcome/index'
  get '/about' => 'welcome#about', as: :about
  get '/about/aug' => 'welcome#aug', as: :aug
  get '/contact' => 'welcome#contact', as: :contact
  get '/sync' => 'welcome#sync', as: :sync
  get '/stats' => 'welcome#stats', as: :stats
  get '/location' => 'welcome#location', as: :location
  get '/collection' => 'welcome#collection', as: :collection
  get '/collection_modal' => 'welcome#collection_modal', as: :collection_modal

  get '/tools/wget/windows' => 'welcome#wget_windows', as: :wget_windows
  get '/tools/wget/src' => 'welcome#wget_src', as: :wget_src

  get '/dua' => 'agreements#dua'
  get '/daua' => 'agreements#daua', as: :daua
  post '/daua' => 'agreements#submit', as: :upload_daua
  patch '/daua' => 'agreements#resubmit', as: :reupload_daua

  root to: 'welcome#index'

end
