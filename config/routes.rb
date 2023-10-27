Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')

  # match 'photos', to: 'photos#show', via: [:get, :post]
  match '/movies/:id/similar',  to: 'movies#select_by_director', as: 'search_directors', via: :get

end
