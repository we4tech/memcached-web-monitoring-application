ActionController::Routing::Routes.draw do |map| 
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }

  # statistics controller related uri
  map.stat_logs "/statistics/logs", :controller => "statistics", :action => "logs"

  # dashboard related uri
  map.dashboard "/dashboard/", :controller => 'dashboard', :action => 'index'
  map.dashboard_tab "/dashboard/:tab", :controller => 'dashboard', :action => 'index'
  map.dashboard_action_delete "/dashboard/delete/cache", :controller => 'dashboard', :action => 'delete_cache'
  map.dashboard_action_flush_all "/dashboard/flush_all/cache", :controller => 'dashboard', :action => 'cache_flush_all'

  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
  
  # Home Page
  map.root :controller => 'dashboard', :action => 'index'

  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
