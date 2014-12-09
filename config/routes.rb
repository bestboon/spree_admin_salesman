Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
  	get "/salesman" => "salesmans#index"
  end
end
