require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'pp'

RM_INSTANCE    = "http://dss-rm.dev/"
API_KEY_NAME   = "dss-rm-api-examples"
API_KEY_SECRET = "da48e7c4702f2a493a7878cab77405a5"

require './models/person.rb'

# Fetch a person and display their name
p = Person.find("cthielen")
puts p.name, "\n"

# Print out their roles grouped by application
p.roles.group_by(&:application_name).each do |i, roles|
  puts "Application: #{i}"
  roles.each do |r|
    puts "\tRole: [#{r.token}, #{r.id}] #{r.name}"
  end
end