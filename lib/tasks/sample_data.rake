namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_projects
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Luigi De Russis",
                       email: "luigi.derussis@polito.it",
                       password: "sword2013",
                       password_confirmation: "sword2013")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    # take users from the Rails Tutorial book since most of them have a "real" profile pic
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_projects
  # generate 50 fake projects for the first 10 users
  users = User.all(limit: 10)
  50.times do
    project_content = Faker::Lorem.sentence(8)
    users.each { |user|  user.projects.create!(content: project_content )}
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  # first user follows user 3 up to 51
  followed_users.each { |followed| user.follow!(followed) }
  # users 4 up to 41 follow back the first user
  followers.each { |follower| follower.follow!(user) }
end