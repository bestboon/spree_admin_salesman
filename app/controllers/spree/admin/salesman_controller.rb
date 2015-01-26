module Spree
  module Admin
    class SalesmanController < Spree::Admin::BaseController

      # Obtenemos el listado de los usuarios que pertenezcan tanto al grupo
      # de venderores como de clientes.
      def index
        @vendedores = Spree::Role.where(name: "vendedor").take.users
        @clientes = Spree::Role.where(name: "cliente").take.users
      end

      def form
        @vendedor = Spree::User.find(params[:id])
        @clientes = Spree::Role.where(name: "cliente").take.users
        @clientes_seleccionados = @vendedor.salesman_clients
      end

      def show
        @vendedor = Spree::User.find(params[:id])
        clientes_vendedor = Spree::User.find(params[:id]).salesman_clients
        clientes = []

        clientes_vendedor.each do |cliente|
          clientes.append(cliente.client_id)
        end

        @cartera_clientes = Spree::User.find(clientes)
      end

      def save
        @vendedor = params[:vendedor]
        @clientes_seleccionados = params[:clientes]
        clientes_vendedor = Spree::User.find(@vendedor).salesman_clients
        clientes = []
        clientes_deseleccionados = []

        clientes_vendedor.each do |cliente|
          clientes.append(cliente.client_id)
        end

        clientes_deseleccionados = clientes - @clientes_seleccionados
        if clientes_deseleccionados.any?
          Spree::SalesmanClient.where(client_id: clientes_deseleccionados).each do |cliente|
            cliente.delete()
          end
        end

        @clientes_seleccionados.each do |cliente|
          Spree::SalesmanClient.find_or_create_by(user_id: @vendedor, client_id: cliente)
        end

        @vendedor = Spree::User.find(params[:vendedor])
        @cartera_clientes = Spree::User.find(clientes)

        redirect_to admin_salesman_show_path(id: @vendedor)
      end

      private
        def model_class
          Spree::Order
        end
    end
  end
end