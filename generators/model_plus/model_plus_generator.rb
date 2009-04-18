module Rails
  module Generator
    class GeneratedAttribute
      
      def is_reference?
        [ :references, :belongs_to ].include?(self.base_type.to_sym)
      end

      def referenced_by?
        [ :has_one, :has_many, :has_and_belongs_to_many ].include?(self.base_type.to_sym)
      end

      def base_type
        #puts self.type.to_s.split('+')[0]
        self.type.to_s.split('+')[0]
        #extract_options[:base_type]
      end
      
      def type_attributes
        @option_attributes = Hash.new("")
        options =  self.type.to_s.split('+')
        options.shift
        options.each do |option|
          case option.downcase.slice(0..1)
          when 'vl'
            # check if there is a length specified
            length = option.slice(2..option.size)
            @option_attributes['vl'] = length
          when 'vu'
            caps_flag = option.last
            if caps_flag == "c"
              @option_attributes['vu'] = ", :case_sensitive => false"
            else
              @option_attributes['vu'] = ""
            end
          when 'cd'
            default = option.slice(2..option.size)
            @option_attributes['cd'] = ", :default => #{default}"
          when 'cn'
            @option_attributes['cn'] = ", :null => false"
          else
            @option_attributes[option] = nil
          end
        end
      #  puts @option_attributes.inspect
        @option_attributes
      end
      
      def option(option_name)
        
      end
      
      def extract_options
        type_information = self.type_attributes
        
        extended_parameters = /([(]+[a-zA-z: ,]+[)]+)/.match(type_information)[0] rescue nil
        
        #unless extended_parameters.blank?
        #  extended_parameters.split(',').each do |option_type|
        #    option_type.strip!
        #    name, value = option_type.split(":")
        #    options[name.to_sym] = value
        #  end
        #end
      end
    end
  end
end

class ModelPlusGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => false

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_name, "#{class_name}Test"

      # Model, test, and fixture directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)
      m.directory File.join('test/fixtures', class_path)

      # Model class, unit test, and fixtures.
      m.template 'model.rb',      File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{file_name}_test.rb")

      unless options[:skip_fixture] 
       	m.template 'fixtures.yml',  File.join('test/fixtures', "#{table_name}.yml")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--skip-fixture",
             "Don't generation a fixture file for this model") { |v| options[:skip_fixture] = v}
    end
end
