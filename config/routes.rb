Rails.application.routes.draw do
  post '/create', to: 'conversions#create'
end