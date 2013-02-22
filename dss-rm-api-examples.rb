require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'pp'

RM_INSTANCE    = "http://dss-rm.dev/"
API_KEY_NAME   = "Test Key"
API_KEY_SECRET = "c787a028023f19870728f07be38979e2"

require './models/person.rb'
require './models/group.rb'
require './models/application.rb'
require './models/role.rb'

begin
  # Used for example purposes
  first_application_id_seen = nil
  first_application_role_id_seen = nil
  
  # Fetch a person and display their name
  puts "Searching for user with login ID 'cthielen' ..."
  p = Person.find("cthielen")
  puts p.name, "\n"

  puts "Display 'cthielen' roles grouped by application"
  # Print out their roles grouped by application
  p.roles.group_by(&:application_id).each do |i, roles|
    first_application_id_seen = i unless first_application_id_seen
    puts "Application ID: #{i}"
    roles.each do |r|
      puts "\tRole: [#{r.token}, #{r.id}] #{r.name}"
    end
  end

  puts "\n"

  puts "Searching for the first application seen above and printing all its roles..."
  # View all roles for an application
  a = Application.find(first_application_id_seen)
  puts a.name, "\n"

  # Print all roles in this application
  a.roles.each do |r|
    first_application_role_id_seen = r.id unless first_application_role_id_seen
    puts "\tRole: [#{r.token}, #{r.id}] #{r.name}"
  end

  puts "\n"  

  # View all members of a role from that application
  puts "Searching for the first role seen above and printing all its entities (members)..."
  r = Role.find(first_application_role_id_seen)
  puts r.name, "\n"
  
  # Print all entities of this application
  r.entities.each do |e|
    puts "\t#{e.id} #{e.name}"
  end

  # Give a person that role


  # Take that role away


  # Create a group with two smartrules


  # View the members of that group

rescue ActiveResource::UnauthorizedAccess
  puts "Couldn't log in. Double-check the API key."
end
