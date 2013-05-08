require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'yaml'
require 'pp'

begin
  # Load the API key information
  $API_KEY = YAML.load_file('api_key.yml')
rescue SystemCallError
  puts "Cannot find api_key.yml. Did you forget to copy api_key.example.yml to api_key.yml and fill in the proper details?"
  exit
end

require './models/person.rb'
require './models/group.rb'
require './models/group_rule.rb'
require './models/application.rb'
require './models/role.rb'
require './models/entity.rb'

begin
  # Used for example purposes
  first_application_id_seen = nil
  first_application_role_id_seen = nil
  
  # Search for all people with 'thi' in their name
  puts "\nSearching for any people with 'thi' in their name ..."
  people = Person.find(:all, :params => {:q => "thi"})
  people.each do |p|
    puts "\tResult: #{p.name}"
  end

  # Search all entities with 'DSS' in their name
  puts "\nSearching for all entities (people and groups) with 'DSS' in their name ..."
  entities = Entity.find(:all, :params => {:q => "DSS"})
  entities.each do |e|
    puts "\tResult: #{e.name}"
  end
  
  # Fetch a person and display their name
  puts "\nSearching for user with login ID 'cthielen' ..."
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
  
  puts "\n"
  
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

  group_name = "Test Group (" + Time.now.to_s + ")"
  puts "Creating a group (#{group_name}) with a rule to include all people with department 'DSS IT SERVICE CENTER'..."
  # Create a group with a smartrule
  g = Group.new
  g.name = group_name
  g.save
  
  # Create a rule and add it to the above group
  r = GroupRule.new
  r.column = "ou"
  r.condition = "is"
  r.value = "DSS IT SERVICE CENTER"
  r.group_id = g.id
  r.save

  # View the members of that rule-calculated group
  puts "\nListing rule-calculated members..."
  g = Group.find(g.id)
  g.members.each do |m|
    puts "\tMember: #{m.name}"
  end

  puts "\n"
  
  # Remove the test group
  puts "Deleting the test group ..."
  g.destroy
  puts "\n"

rescue ActiveResource::UnauthorizedAccess
  puts "Couldn't log in. Double-check the API key."
end
