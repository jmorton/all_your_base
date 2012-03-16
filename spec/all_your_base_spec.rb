require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Person < ActiveRecord::Base
  include AllYourBase
  base :foo
end


class Place < ActiveRecord::Base
  include AllYourBase
  base :bar
end


describe AllYourBase do

  before(:all) do
    Person.connection.create_table(:people)
    Place.connection.create_table(:places)
  end

  after(:all) do
    Person.connection.drop_table :people
    Place.connection.drop_table :places
  end

  it "adds class level behavior to ActiveRecord::Base" do
    Person.should respond_to(:base)
  end

  it "returns an alternative connection" do
    Person.connection.table_exists?(:places).should be_false
    Place.connection.table_exists?(:people).should be_false
  end

end
