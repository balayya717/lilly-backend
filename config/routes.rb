Rails.application.routes.draw do
  get "health", to: "health#show"

  resources :monthly_goals, only: [:index, :show, :create, :update, :destroy] do
    resources :weekly_milestones, only: [:index, :create, :update, :destroy]
  end

  resources :daily_logs, only: [:index, :create, :update]
end
