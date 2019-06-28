Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/positives", to: "pages#show_positives"
  get "/negatives", to: "pages#show_negatives"
end
