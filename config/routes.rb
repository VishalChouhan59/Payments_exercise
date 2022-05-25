Rails.application.routes.draw do
  resources :loans, defaults: {format: :json} do
    member do
      resources :payments, param: :payment_id, only: [:index, :show, :create]
    end
  end
end
