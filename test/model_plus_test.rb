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
