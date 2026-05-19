puts "Cleaning the database..."
# We must destroy them in this specific order so we don't hit foreign key errors!
Expense.destroy_all
Project.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating Wollow Employees..."

# 1. The Administrator
admin = User.create!(
  first_name: "Ivelin",
  last_name: "Zlatanov",
  email: "i.zlatanov@wollow.com",
  password: "iZlatanov123",
  role: "admin"
)

# 2. The Project Manager
pm = User.create!(
  first_name: "James",
  last_name: "Bond",
  email: "j.bond@wollow.com",
  password: "bond123James",
  role: "project_manager"
)

# 3. The Developer
dev = User.create!(
  first_name: "Michael",
  last_name: "Jordan",
  email: "m.jordan@wollow.com",
  password: "michaelJ123",
  role: "developer"
)

puts "Creating Categories..."
Category.create!(name: "Software & Licenses")
Category.create!(name: "Travel & Accommodation")
Category.create!(name: "Hardware & Equipment")

puts "Creating Projects..."
# Notice how we use `pm.id` to automatically assign James Bond as the manager!
Project.create!(
  name: "Automated Cost Engine", 
  client_name: "Wollow Internal", 
  manager_id: pm.id, 
  status: "Active"
)

Project.create!(
  name: "Mobile App Redesign", 
  client_name: "Acme Corp", 
  manager_id: pm.id, 
  status: "Active"
)

Project.create!(
  name: "Cloud Migration Initiative", 
  client_name: "Globex Inc", 
  manager_id: pm.id, 
  status: "Planning"
)

Project.create!(
  name: "Security Audit 2026", 
  client_name: "Initech", 
  manager_id: pm.id, 
  status: "Completed"
)

puts "Successfully created #{User.count} Users, #{Category.count} Categories, and #{Project.count} Projects!"