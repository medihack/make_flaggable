require 'spec_helper'
require 'action_controller'
require 'generator_spec/test_case'
require 'generators/make_flaggable/make_flaggable_generator'

describe MakeFlaggableGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("/tmp", __FILE__)
  tests MakeFlaggableGenerator

  before do
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      directory "db" do
        directory "migrate" do
          migration "create_make_flaggable_tables" do
            contains "class CreateMakeFlaggableTables"
            contains "create_table :flaggings"
          end
        end
      end
    }
  end
end
