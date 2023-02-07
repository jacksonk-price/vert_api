Rails.application.routes.draw do
  post '/convert', to: 'downloads#convert'
end
