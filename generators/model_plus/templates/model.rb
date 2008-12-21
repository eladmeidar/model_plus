class <%= class_name %> < ActiveRecord::Base
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% attributes.select(&:referenced_by?).each do |attribute| -%>
  <%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% attr_accessible = [] %>
<% attributes.each do |attribute| -%>
  <% attr_accessible << ":" + attribute.name if attribute.type_attributes =~ /a/ -%>
<% end -%>
<% if !attr_accessible.empty? -%>
  attr_accessible <%= attr_accessible.join(", ") %>
<% end -%>
end
