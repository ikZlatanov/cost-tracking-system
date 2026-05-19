Rails.application.routes.draw do
  root "pages#home"
  
  # Authentication
  get "login", to: "pages#login"
  post "login", to: "sessions#create" 
  delete "logout", to: "sessions#destroy"

  # Dashboards
  get "admin_dashboard", to: "dashboards#admin"
  get "pm_dashboard", to: "dashboards#project_manager"
  get "developer_dashboard", to: "dashboards#developer"
  get "admin_analytics", to: "dashboards#analytics"
  # Resources
  resources :expenses
  resources :csv_imports, only: [:new, :create]
end