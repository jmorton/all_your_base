$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'all_your_base'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  module ActiveRecord
    class Base
      def self.configurations        
        YAML.load_file('spec/config/database.yml')
      end
    end
  end

  class Rails
    def self.env
      'test'
    end
  end

end
