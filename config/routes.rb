Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "pages#home"
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [ :show, :create, :edit, :update , :destroy ]
  resources :trips, only: [ :index, :show, :new, :create, :destroy ] do
    resources :trip_activities, only: [ :new, :create ] #:index
    resources :bookings, only: [ :new, :create, :index, :show ]
    resources :tasks, only: [ :new, :create, :index ]
    resources :activities, only: [:index, :show]
    get "firsthotel_booking", to: "bookings#firsthotel_for_trip"
  end
  resources :tasks, only: [ :show, :update, :destroy ]

  resources :activities, only: [ :new, :create ]

  # route for aditional pages
  get '/cgu' => 'pages#cgu'
  
  # Special routes for notifs stuff
  get "/check_for_notif", to: "notifications#check_for_notif"
  get "/hide_notif_empty_activities", to: "notifications#hide_notif_empty_activities"
  get "/hide_notif_new_booking", to: "notifications#hide_notif_new_booking"
end
