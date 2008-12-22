class <%= class_name %> < ActiveRecord::Base
<% attributes.select(&:is_reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% attributes.select(&:referenced_by?).each do |attribute| -%>
  <%= attribute.base_type %> :<%= attribute.name %>
<% end -%>
<% attr_accessible = [] %>
<% attributes.each do |attribute| -%>
  <% attr_accessible << ":" + attribute.name if attribute.type_attributes =~ /a/ -%>
<% end -%>
<% if !attr_accessible.empty? -%>
  attr_accessible <%= attr_accessible.join(", ") %>
<% end -%>
<% present = [] %>
<% attributes.each do |attribute| -%>
  <% present << ":" + attribute.name if attribute.type_attributes =~ /p/ && attribute.base_type != "boolean" -%>
  <%= "validates_inclusion_of :#{attribute.name}, :in => [true, false]" if attribute.type_attributes =~ /p/ && attribute.base_type == "boolean" %>
<% end -%>
<% if !present.empty? -%>
  validates_presence_of <%= present.join(", ") %>
<% end -%>
end
