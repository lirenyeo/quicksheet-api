Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/expenses', to: 'spreadsheets#add_expense'
      post '/incomes', to: 'spreadsheets#add_income'
      get '/data', to: 'spreadsheets#read'
    end
  end
end