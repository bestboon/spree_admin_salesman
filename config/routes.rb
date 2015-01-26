Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
  	post "/salesman/save" => "salesman#save"
  	get "/salesman" => "salesman#index"
  	get "/salesman/form" => "salesman#form"
  	get "/salesman/show" => "salesman#show"
    get "/order/:order_id/approval/request" => "approval#index", as: "send_approval"
  end
end
