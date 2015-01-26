module Spree
  module Api
    LineItemsController.class_eval do
      def update
        # TODO BACKORDER
        current_order = order
        @line_item = find_line_item
        if @order.contents.update_cart(line_items_attributes)
          @line_item.reload
          respond_with(@line_item, default_template: :show)
        else
          invalid_resource!(@line_item)
        end
      end
    end
  end
end
