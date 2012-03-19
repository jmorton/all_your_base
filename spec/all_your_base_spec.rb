require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


class Person < ActiveRecord::Base
  include AllYourBase
  base :foo
  belongs_to :place
end

class Place < ActiveRecord::Base
  include AllYourBase
  base :bar
  has_many :people
end


describe AllYourBase do

  before(:all) do
    Person.connection.create_table(:people) do |t|
      t.string :name
      t.references :place
    end
    Place.connection.create_table(:places) do |t|
      t.string :name
    end
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

  context "associations between models stored in different databases" do

    before(:all) do
      @home  = Place.create(:name => 'home')
      @work  = Place.create(:name => 'work')
      @me    = Person.create(:name => 'me', :place => @home)
      @you   = Person.create(:name => 'you', :place => @home)
      @them  = Person.create(:name => 'them', :place => @work)
    end    

    it "works with belongs_to associations, even across databases" do
      @me.place.should eq(@home)
      @you.place.should eq(@home)
      @them.place.should eq(@work)
    end

    it "works with has_many associations, even across databases" do
      @home.people.should include(@me, @you)
      @home.people.should_not include(@them)
    end

  end

end
