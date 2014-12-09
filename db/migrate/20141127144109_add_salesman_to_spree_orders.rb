class AddSalesmanToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :salesman, :string
  end
end
