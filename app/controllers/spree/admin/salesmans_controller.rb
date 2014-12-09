module Spree
  module Admin
    class SalesmansController < Spree::Admin::BaseController

      def index
        @user = Spree::User.all
      end
      private
        def model_class
          Spree::Order
        end
    end
  end
end