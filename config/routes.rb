Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/movies', to: 'movies#index', as: 'movies'
  get '/movies/:title', to: 'movies#show', as: 'movie'
  post '/movies', to: 'movies#create'

  get '/customers', to: 'customers#index', as: 'customers'
  post '/customers', to: 'customers#create'

  post '/rentals/:title/checkout', to: 'rentals#checkout_movie', as: 'checkout'
  delete '/rentals/:title/checkin', to: 'rentals#checkin_movie', as: 'checkin'


  # get '/zomg', to: 'application#index', as: 'zomg'
end
