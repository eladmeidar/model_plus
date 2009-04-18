# First five tests borrowed directly from Rails - in the interest
# of merging cleanly back to core code later
require 'test_helper'

class RailsModelGeneratorTest < GeneratorTestCase

  def test_model_generates_resources
    run_generator('model_plus', %w(Product name:string))

    assert_generated_model_for :product
    assert_generated_fixtures_for :products
    assert_generated_migration :create_products
  end

  def test_model_skip_migration_skips_migration
    run_generator('model_plus', %w(Product name:string --skip-migration))

    assert_generated_model_for :product
    assert_generated_fixtures_for :products
    assert_skipped_migration :create_products
  end

  def test_model_with_attributes_generates_resources_with_attributes
    run_generator('model_plus', %w(Product name:string supplier_id:integer created_at:timestamp))

    assert_generated_model_for :product
    assert_generated_fixtures_for :products
    assert_generated_migration :create_products do |t|
      assert_generated_column t, :name, :string
      assert_generated_column t, :supplier_id, :integer
      assert_generated_column t, :created_at, :timestamp
    end
  end

  def test_model_with_reference_attributes_generates_belongs_to_associations
    run_generator('model_plus', %w(Product name:string supplier:references))

    assert_generated_model_for :product do |body|
      assert body =~ /^\s+belongs_to :supplier/, "#{body.inspect} should contain 'belongs_to :supplier'"
    end
  end

  def test_model_with_belongs_to_attributes_generates_belongs_to_associations
    run_generator('model_plus', %w(Product name:string supplier:belongs_to))

    assert_generated_model_for :product do |body|
      assert body =~ /^\s+belongs_to :supplier/, "#{body.inspect} should contain 'belongs_to :supplier'"
    end
  end
  
  def test_model_with_belongs_to_attributes_generates_add_index_statement
    run_generator('model_plus', %w(Product name:string supplier:belongs_to))
    
    assert_generated_migration :create_products do |t|
      assert_generated_index t, :products, :supplier
    end
  end
  
  def test_model_with_has_many_attributes_generates_has_many_associations
    run_generator('model_plus', %w(Supplier name:string products:has_many))

    assert_generated_model_for :supplier do |body|
      assert body =~ /^\s+has_many :products/, "#{body.inspect} should contain 'has_many :products'"
    end
  end
  
  def test_model_with_has_one_attributes_generates_has_one_associations
    run_generator('model_plus', %w(User name:string account:has_one))

    assert_generated_model_for :user do |body|
      assert body =~ /^\s+has_one :account/, "#{body.inspect} should contain 'has_one :account'"
    end
  end
  
  def test_model_with_has_and_belongs_to_many_attributes_generates_habtm_associations
    run_generator('model_plus', %w(Product name:string parts:has_and_belongs_to_many))

    assert_generated_model_for :product do |body|
      assert body =~ /^\s+has_and_belongs_to_many :parts/, "#{body.inspect} should contain 'has_and_belongs_to_many :parts'"
    end
  end
  

  def test_model_extended_options_attr_accessor
    run_generator('model_plus', %w(Product name:string+aa))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+attr_accessible :name/, "#{body.inspect} should contain 'attr_accessible :name'"
    end
  end
  
  def test_model_extended_options_attr_protected
    run_generator('model_plus', %w(Product name:string+ap))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+attr_protected :name/, "#{body.inspect} should contain 'attr_protected :name'"
    end
  end
  
  def test_model_extended_options_validates_presence_of
    run_generator('model_plus', %w(Product name:string+vp))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_presence_of :name/, "#{body.inspect} should contain 'validates_presence_of :name'"
    end
  end
  
  def test_model_extended_options_validates_length_of
    run_generator('model_plus', %w(Product name:string+vl))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_length_of :name/, "#{body.inspect} should contain 'validates_length_of :name'"
    end
  end
  
  def test_model_extended_options_validates_length_of_with_length
    run_generator('model_plus', %w(Product name:string+vl5))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_length_of :name, :minimum => 5/, "#{body.inspect} should contain 'validates_length_of :name, :minimum => 5'"
    end
  end
  
  def test_model_extended_options_validates_numericality_of
    run_generator('model_plus', %w(Product age:integer+vn))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_numericality_of :age/, "#{body.inspect} should contain 'validates_numericality_of :age'"
    end
  end
  
  def test_model_extended_options_validates_numericality_of_integer
    run_generator('model_plus', %w(Product age:integer+vi))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_numericality_of :age, :only_integer => true/, "#{body.inspect} should contain 'validates_numericality_of :age, :only_integer => true'"
    end
  end
  
  def test_model_extended_options_validates_uniqueness_of
    run_generator('model_plus', %w(Product username:string+vu))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_uniqueness_of :username/, "#{body.inspect} should contain 'validates_uniqueness_of :username'"
    end
  end
  
  def test_model_extended_options_validates_uniqueness_of_no_case_sensitive
    run_generator('model_plus', %w(Product username:string+vuc))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_uniqueness_of :username, :case_sensitive => false/, "#{body.inspect} should contain 'validates_uniqueness_of :username, :case_sensitive => false'"
    end
  end
  
  def test_model_extended_options_validates_uniqueness_of_no_case_sensitive
    run_generator('model_plus', %w(Product email:string+vc))
    assert_generated_model_for :product do |body|
      assert body =~ /^\s+validates_confirmation_of :email/, "#{body.inspect} should contain 'validates_confirmation_of :email'"
      assert body =~ /^\s+validates_presence_of :email_confirmation/, "#{body.inspect} should contain 'validates_presence_of :email_confirmation'"
    end
  end
  
  def test_migration_with_default
    run_generator('model_plus', %w(Product name:string+vl3 age:integer+cd5))

    assert_generated_migration :create_products do |t|
      assert_generated_column t, 'age, :default => 5', :integer
      assert_generated_column t, 'name', :string
    end
  end
  
  def test_migration_with_default_empty
    run_generator('model_plus', %w(Product name:string+vl3 age:integer+cd))

    assert_generated_migration :create_products do |t|
      assert_generated_column t, 'age', :integer
      assert_generated_column t, 'name', :string
    end
  end
  
  def test_migration_with_not_null
    run_generator('model_plus', %w(Product name:string+vl3 age:integer+cn))

    assert_generated_migration :create_products do |t|
      assert_generated_column t, 'age, :null => false', :integer
      assert_generated_column t, 'name', :string
    end
  end
  
  def test_migration_with_not_null_and_default
     run_generator('model_plus', %w(Product name:string+vl3 age:integer+cn+cd5))

     assert_generated_migration :create_products do |t|
       assert_generated_column t, 'age, :default => 5, :null => false', :integer
       assert_generated_column t, 'name', :string
     end
  end
   
  def test_migration_with_string_default
    run_generator('model_plus', %w(Product name:string+cd"elad"))

    assert_generated_migration :create_products do |t|
      assert_generated_column t, 'name, :default => "elad"', :string
    end
  end
  
  def test_has_referencing_attributes_do_not_add_column_to_migration
    run_generator('model_plus', %w(Supplier name:string products:has_many account:has_one parts:has_and_belongs_to_many))

    assert_generated_migration :create_suppliers do |t|
      assert_no_generated_column t, :products
      assert_no_generated_column t, :account
      assert_no_generated_column t, :parts
    end
  end
  
  def test_has_referencing_attributes_do_not_add_column_to_fixtures
    run_generator('model_plus', %w(Supplier name:string products:has_many account:has_one parts:has_and_belongs_to_many))

    assert_generated_fixtures_for :suppliers do |f|
      assert_no_generated_attribute f, :products
      assert_no_generated_attribute f, :account
      assert_no_generated_attribute f, :parts
    end
  end
end
