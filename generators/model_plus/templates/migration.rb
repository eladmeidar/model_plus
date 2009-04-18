<%
 indexed_foreign_keys = attributes.select {|attr| attr.is_reference? }
%>

class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% for attribute in attributes -%>
  <% unless attribute.referenced_by? %>
      t.<%= attribute.base_type %> :<%= attribute.name %><%= attribute.type_attributes['cd'] if attribute.type_attributes.has_key?('cd')%><%= attribute.type_attributes['cn'] if attribute.type_attributes.has_key?('cn')%>
  <% end -%>
<% end -%>
<% unless options[:skip_timestamps] %>
      t.timestamps
<% end -%>
    end
    
    <% for attribute in indexed_foreign_keys %>
      add_index :<%= table_name %>, :<%= attribute.name + "_id" %>
    <% end %>
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
