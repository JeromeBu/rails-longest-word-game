Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'game', to: 'pages#start_game'

get 'score', to: 'pages#give_score'

end
