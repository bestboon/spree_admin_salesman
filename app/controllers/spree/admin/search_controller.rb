module Spree
  module Admin
    class SearchController < Spree::Admin::BaseController
      # http://spreecommerce.com/blog/2010/11/02/json-hijacking-vulnerability/
      before_action :check_json_authenticity, only: :index
      respond_to :json

      # TODO: Clean this up by moving searching out to user_class_extensions
      # And then JSON building with something like Active Model Serializers
      def users
        if params[:ids]
          @users = Spree.user_class.where(:id => params[:ids].split(','))
        else
          if spree_current_user.has_spree_role?("vendedor")
            lista_clientes = Array.new
            clientes = spree_current_user.salesman_clients
            clientes.each do |cliente|
            lista_clientes.append(cliente.client_id)
            end
            @users = Spree.user_class.find(lista_clientes) 
          else
            @users = Spree.user_class.ransack({
              :m => 'or',
              :email_start => params[:q],
              :ship_address_firstname_start => params[:q],
              :ship_address_lastname_start => params[:q],
              :bill_address_firstname_start => params[:q],
              :bill_address_lastname_start => params[:q]
            }).result.limit(10)

          end
        end
      end


      private
        # Asociamos este controlador a una clase del modelo
        # para poder gestionar los permisos de este controlador
        # con la gema de cancan a traves de este modelo que asociamos.
        def model_class
          Spree::Order
        end
    end
  end
end