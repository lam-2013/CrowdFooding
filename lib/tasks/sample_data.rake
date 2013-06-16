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
    project_titolo = Faker::Lorem.words(2)
    project_descrizione = Faker::Lorem.sentence(20)
    project_categoria = 'luoghi'
    project_data_creazione = Time.now
    project_data_fine = project_data_creazione + 2.week
    r = Random.new
    project_goal = r.rand(100.00..5000.00)
    project_budget_attuale = r.rand(50.00..8000.00)
    project_tags = '1,2,3,4,5'
    users.each { |user|  user.projects.create!(titolo: project_titolo,
                                               descrizione: project_descrizione,
                                               categoria: project_categoria,
                                               tags: project_tags,
                                               data_creazione: project_data_creazione,
                                               data_fine: project_data_fine,
                                               budget_attuale: project_budget_attuale,
                                               goal: project_goal )}
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