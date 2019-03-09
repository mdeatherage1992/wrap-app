Rails.application.routes.draw do

root to: "jobs#home"
resources :jobs do
  collection { post :import }
end

end
