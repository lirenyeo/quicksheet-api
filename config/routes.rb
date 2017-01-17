Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/expenses', to: 'expenses#create'
    end
  end
end