Rails.application.routes.draw do
  post '/convert', to: 'conversions#convert'
end