class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% for attribute in attributes -%>
  <% unless attribute.referenced_by? %>
      t.<%= attribute.base_type %> :<%= attribute.name %>
  <% end -%>
<% end -%>
<% unless options[:skip_timestamps] %>
      t.timestamps
<% end -%>
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
