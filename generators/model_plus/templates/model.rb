class <%= class_name %> < ActiveRecord::Base
  <% attributes.select(&:is_reference?).each do |attribute| -%>
    belongs_to :<%= attribute.name.downcase %>
  <% end -%>
<% attributes.select(&:referenced_by?).each do |attribute| -%>
  <%= attribute.base_type %> :<%= attribute.name.downcase %>
<% end -%>
<% attr_accessible = present = bool_present = numerical = integral = unique = [] %>
<% attributes.each do |attribute| -%>
  <% attr_accessible << ":" + attribute.name if attribute.type_attributes =~ /a/ -%>
  <% numerical << ":" + attribute.name if attribute.type_attributes =~ /n/ -%>
  <% integral << ":" + attribute.name if attribute.type_attributes =~ /i/ -%>
  <% unique << ":" + attribute.name if attribute.type_attributes =~ /u/ -%>
  <% present << ":" + attribute.name if attribute.type_attributes =~ /p/ && attribute.base_type != "boolean" -%>
  <% bool_present << ":" + attribute.name if attribute.type_attributes =~ /p/ && attribute.base_type == "boolean" -%>
<% end -%>
<% if !attr_accessible.empty? -%>
  attr_accessible <%= attr_accessible.join(", ") %>
<% end -%>
<% if !present.empty? -%>
  validates_presence_of <%= present.join(", ") %>
<% end -%>
<% if !bool_present.empty? -%>
  validates_inclusion_of <%= bool_present.join(", ") %>, :in => [true, false]
<% end -%>
<% if !numerical.empty? -%>
  validates_numericality_of <%= numerical.join(", ") %>
<% end -%>
<% if !integral.empty? -%>
  validates_numericality_of <%= integral.join(", ") %>, :only_integer => true
<% end -%>
<% if !unique.empty? -%>
  validates_uniqueness_of <%= unique.join(", ") %>
<% end -%>
end
