Rails.application.routes.draw do
  post '/conversion/create', to: 'conversions#create'
end