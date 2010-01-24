require 'irb'
require 'memcached'

$logger = Friendly::Logger.new(STDOUT)
Friendly.configure :adapter => "sqlite",
                   :logger  => $logger

$cache = Memcached.new

begin
  $cache.get("a")
rescue Memcached::SystemError => e
  $logger.warn("I couldn't find a memcached server running on this machine. Start one so you can see Friendly's caching in action.".red)
  $cache = nil
rescue Memcached::NotFound => e
  $logger.info("Found a memcached server. Caching enabled!".green)
  Friendly.cache = $cache
end

class User
  include Friendly::Document

  attribute :name, String
  attribute :age,  Integer

  indexes :age
  indexes :name, :created_at
  indexes :created_at

  has_many :addresses

  caches_by :id if $cache
end

class Address
  include Friendly::Document

  attribute :user_id, Integer
  attribute :street,  String

  indexes   :user_id

  caches_by :id if $cache
end

Friendly.create_tables!

puts "\n"
puts "Welcome to Friendly shell. You have two models: User, and Address."
puts "Their definitions look like this:"

puts <<-__END__
class User
  include Friendly::Document

  attribute :name, String
  attribute :age,  Integer

  indexes :age
  indexes :name, :created_at
  indexes :created_at

  has_many :addresses#{"\n\n  caches_by :id" if $cache}
end

class Address
  include Friendly::Document

  attribute :user_id, Integer
  attribute :street,  String

  indexes   :user_id#{"\n\n  caches_by :id" if $cache}
end
__END__

IRB.start
