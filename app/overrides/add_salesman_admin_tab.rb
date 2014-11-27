Deface::Override.new(:virtual_path => "spree/admin/shared/_tabs",
                 :name => "add_seller_tab_to_admin_menu",
                 :insert_before => "erb[silent]:contains('if Spree.user_class && can?(:admin, Spree.user_class)')",
                 :text => "<% if Spree.user_class && can?(:admin, Spree.user_class) %>
                 <%= tab :salesmans,label: Spree.t('salesmans'), :icon => 'icon-th-large', url: spree.edit_admin_general_settings_path %>
                 <% end %>")