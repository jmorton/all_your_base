 require 'active_record'

module AllYourBase
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def base(name)
      establish_connection(ActiveRecord::Base.configurations[name.to_s][Rails.env])
    end
  end

end
