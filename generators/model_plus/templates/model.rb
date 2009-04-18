class <%= class_name %> < ActiveRecord::Base
  <% attributes.select(&:is_reference?).each do |attribute| -%>
    belongs_to :<%= attribute.name.downcase %>
  <% end -%>
<% attributes.select(&:referenced_by?).each do |attribute| -%>
  <%= attribute.base_type %> :<%= attribute.name.downcase %>
<% end -%>
<% attr_accessible = attr_protected = confirmation = present = length = bool_present = numerical = integral = unique = [] %>
<% attributes.each do |attribute| -%>
  <% attr_accessible << ":" + attribute.name if attribute.type_attributes.has_key?('aa') -%>
  <% attr_protected << ":" + attribute.name if attribute.type_attributes.has_key?('ap') -%>
  <% numerical << ":" + attribute.name if attribute.type_attributes.has_key?('vn') -%>
  <% confirmation << ":" + attribute.name if attribute.type_attributes.has_key?('vc') -%>
  <% integral << ":" + attribute.name if attribute.type_attributes.has_key?('vi') -%>
  <% unique << ":" + attribute.name + attribute.type_attributes['vu'] if attribute.type_attributes.has_key?('vu') -%>
  <% length << ":" + attribute.name + ", :minimum => #{attribute.type_attributes['vl']}" if attribute.type_attributes.has_key?('vl') -%>
  <% present << ":" + attribute.name if attribute.type_attributes.has_key?('vp') && attribute.base_type != "boolean" -%>
  <% bool_present << ":" + attribute.name if attribute.type_attributes.has_key?('vp') && attribute.base_type == "boolean" -%>
<% end -%>
<% if !attr_accessible.empty? -%>
  attr_accessible <%= attr_accessible.join(", ") %>
<% end -%>
<% if !attr_protected.empty? -%>
  attr_protected <%= attr_protected.join(", ") %>
<% end -%>

<% if !present.empty? -%>
  validates_presence_of <%= present.join(", ") %>
<% end -%>

<% if !length.empty? -%>
  <% length.each do |length_validated| %>
    validates_length_of <%= length_validated %>
  <% end %>
<% end -%>

<% if !confirmation.empty? -%>
  <% confirmation.each do |confirmation_validated| %>
    validates_confirmation_of <%= confirmation %>
    validates_presence_of <%= confirmation %>_confirmation
  <% end %>
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
