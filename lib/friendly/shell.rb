require 'irb'

Friendly.configure :adapter => "sqlite",
                   :logger  => Friendly::Logger.new(STDOUT)

class User
  include Friendly::Document

  attribute :name, String
  attribute :age,  Integer

  indexes :age
  indexes :name, :created_at
  indexes :created_at

  has_many :addresses
end

class Address
  include Friendly::Document

  attribute :user_id, Integer
  attribute :street,  String

  indexes   :user_id
end

Friendly.create_tables!
IRB.start
