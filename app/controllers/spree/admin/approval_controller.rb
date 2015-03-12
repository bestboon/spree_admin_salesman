module Spree
  module Admin
    class ApprovalController < Spree::Admin::BaseController
      before_action :load_order
      helper 'spree/products', 'spree/orders'

      def index
        request_approval
      end

      ##
      # 
      ##
      def request_approval
        if @order
          split_order
          # Almacenamos la orden actual como la principal
          @main_order = @order
          # Hacemos nula la orden actual
          @order = nil
          # Generamos las ordenes nuevas por taxonomias y limite de lineas
          generate_orders
          # Eliminamos la orden principal.
          # delete_lines_main_order
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          # redirect_to admin_path
        else
          redirect_to edit_admin_order_url(@order)
        end
      end

      # Metodo que se encarga de eliminar la orden principal y sus lineas
      def delete_lines_main_order
        # Eliminamos las lineas de la orden principal
        @main_order.line_items.each do |line_item|
          line_item.delete
        end
        # Eliminamos la orden principal
        @main_order.delete
      end

      # Metodo que se encarga de dividir las ordenes por taxonomias.
      def split_order
        # Lineas de productos identificadas por taxonomias
        @taxonomias = Spree::Taxonomy.all
        # Creamos el hash de array donde almacenaremos las lineas de productos por taxonomias.
        @productos_por_taxonomias =  Hash.new
        # LLenamos el hash
        @taxonomias.each do |taxonomia|
          @productos_por_taxonomias[taxonomia.name] = []
        end
        @order.line_items.each do |item|
          item.variant.product.taxons.each do |taxon|
            if @productos_por_taxonomias[taxon.name]
              @productos_por_taxonomias[taxon.name].append(item)
            end
          end
        end
      end

      # Metodo que se encarga de generar las nuevas ordenes partiendo de la principal
      # tomando encuenta las taxonomias y el limite de lineas por factura configurado.
      def generate_orders
        @productos_por_taxonomias.each do |taxonomia, line_items|
          # Picamos la orden actual en sub-ordenes si la orden excede la cantidad de lineas configuradas en el backend par auna orden.
          line_items.each_slice(Spree::Config[:max_order_lines]) do |line_items_slice|
            line_items_slice.each do |line_item|
              @order = nil
              current_order = Spree::Order.new( user_id: spree_current_user.id,
                                                bill_address_id: @main_order.bill_address_id,
                                                ship_address_id: @main_order.ship_address_id,
                                                created_by_id: spree_current_user.id )
              populator = Spree::OrderPopulator.new(current_order, current_order.currency)
              populator.populate(line_item.variant_id, line_item.quantity)
            end
          @current_order = spree_current_user.last_incomplete_spree_order
          add_salesman
          @current_order.next
          @current_order.next
          end
        end
      end

      def add_salesman
          @current_order.email = @main_order.email
          @current_order.salesman = spree_current_user.email
          @current_order.user_id = Spree::User.where(email: @main_order.email).take.id
          @current_order.save
        end

      private
        def load_order
          #@order = Order.includes(:adjustments).find_by_number!(params[:order_id])
          @order = Spree::Order.find_by_number!(params[:order_id])
        end

        def model_class
          Spree::Order
        end
    end
  end
end