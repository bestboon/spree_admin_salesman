Deface::Override.new(:virtual_path => "spree/admin/shared/_order_submenu",
                 :name => "add_complete_order_tab",
                 :insert_bottom => "ul",
				 :text => "<% if can?(:update, @order) && @order.address? %>
							<li<%== 'class=active' if current == 'Send to approve' %> data-hook='admin_order_tabs_complete'>
							<%= link_to_with_icon 'credit-card', Spree.t(:send_to_approve), admin_send_approval_url(@order) %>
							</li>
							<% end %>")