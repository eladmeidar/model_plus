class <%= class_name %> < ActiveRecord::Base
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% attributes.select(&:referenced_by?).each do |attribute| -%>
  <%= attribute.type %> :<%= attribute.name %>
<% end -%>
end
