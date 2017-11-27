Rails.application.routes.draw do
  get 'game', to: 'games_controller#game'

  get 'score', to: 'games_controller#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
