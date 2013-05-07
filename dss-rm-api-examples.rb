require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'pp'

RM_INSTANCE    = "http://dss-rm.dev/"
API_KEY_NAME   = "dss-rm-api-examples"
API_KEY_SECRET = "17da2fc3ff24a4366d63e40a976bb240"

require './models/person.rb'
require './models/group.rb'
require './models/group_rule.rb'
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

  puts "Searching for the first application seen above (#{first_application_id_seen}) and printing all its roles..."
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
  puts "Searching for the first role seen above (#{first_application_role_id_seen}) and printing all its entities (members)..."
  r = Role.find(first_application_role_id_seen)
  puts r.name, "\n"
  
  # Print all entities of this application
  r.entities.each do |e|
    puts " %-7s %-30s" % [e.id, e.name]
  end
  
  # # Back up the role_ids of an individual so we don't destroy them with this example
  # role_ids = p.role_ids
  # 
  # # Give a person that role
  # p.role_ids << first_application_role_id_seen
  # p.save
  # 
  # # Take that role away
  # p.role_ids.delete(first_application_role_id_seen)
  # p.save
  # 
  # # Restore original role_ids (necessary in case first_application_role_id_seen was assigned to them before example began)
  # p.role_ids = role_ids
  # p.save

  # Create a group with a smartrule
  g = Group.new
  g.name = "Test Group (" + Time.now.to_s + ")"
  #r = GroupRule.new
  #r.column = "loginid"
  #r.condition = "is"
  #r.value = "cthielen"
  #g.rules << r
  #g.save

  # View the members of that group

rescue ActiveResource::UnauthorizedAccess
  puts "Couldn't log in. Double-check the API key."
end
