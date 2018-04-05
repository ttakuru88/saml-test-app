Rails.application.routes.draw do
  root 'home#index'

  get :private, to: 'home#private'
  get :sign_out, to: 'home#sign_out'

  resource :saml, only: [], controller: :saml do
    get :sso
    post :acs
    get :metadata
  end
end
