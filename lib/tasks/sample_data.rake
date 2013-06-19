namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    make_users
    make_projects
    make_contributions
    make_relationships

  end
end

def make_users
  city=["Torino","Milano","Bologna","Palermo","Genova","Roma"]
  sesso=["M","F"]
  r = Random.new
  User.create!(name: 'Giovanni',
               cognome:'Bonaventura',
               email: 'gionnyb@hotmail.it',
               luogo: 'Torino',
               sito_web: 'http://www.overc.it',
               sesso: 'M',
               descrizione: 'Amo la natura il vivere sano in tutti i sensi',
               img_copertina: 'copertine_users'.concat('/copertina1.jpg'),
               nascita: Time.local(1986,4,4),
               password: 'giogio',
               password_confirmation: 'giogio')
  100.times do |n|
    name  = Faker::Name.first_name
    cognome = Faker::Name.last_name
    user_descrizione = Faker::Lorem.sentence(20)
    # take users from the Rails Tutorial book since most of them have a "real" profile pic
    email = Faker::Internet.email(name)
    sito_web= Faker::Internet.url
    password  = "password"
    user_luogo = city[r.rand(city.size)]
    User.create!(name: name,
                 cognome:cognome,
                 email: email,
                 luogo: user_luogo,
                 sito_web: sito_web,
                 sesso: sesso[r.rand(sesso.size)],
                 descrizione:user_descrizione,
                 img_copertina: 'copertine_users'.concat('/copertina1.jpg'),
                 nascita: time_rand,
                 password: password,
                 password_confirmation: password)
  end
end

def make_projects


  # generate 20 fake projects for the first 10 users
  city=["Torino","Milano","Bologna","Palermo","Genova","Roma"]
  categoria=["ART & ENTERTAINMENT","LIFESTYLE & TECHNOLOGY","SOCIAL INNOVATION","EVENTI","FOOD"]
  r = Random.new
  users = User.all(limit: 10)
  20.times do

    project_titolo = Faker::Lorem.sentence(1)
    project_descrizione = Faker::Lorem.sentence(20)
    project_luogo = city[r.rand(city.size)]
    project_categoria = categoria[r.rand(categoria.size)]
    project_data_creazione = time_rand Time.local(2012, 1, 1), Time.local(2013, 8, 7)
    project_data_fine = project_data_creazione + 2.week
    contributions_servizio = Faker::Lorem.sentence(2)
    project_goal = r.rand(100.00..5000.00)
    project_budget_attuale = r.rand(50.00..8000.00)
    project_tags = '1,2,3,4,5'
    users.each { |user|  user.projects.create!(titolo: project_titolo,
                                               luogo: project_luogo,
                                               descrizione: project_descrizione,
                                               categoria: project_categoria,
                                               img_copertina: 'copertine_projects'.concat('/copertina1.jpg'),
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


def time_rand from = Time.now - 80.years, to = Time.now - 18.years
  Time.at(from + rand * (to.to_f - from.to_f))
end


def make_contributions
  projects = Project.all(limit: 10)
  10.times do
  contributions_servizio = Faker::Lorem.sentence(5)
  projects.each { |project| project.contributions.create!(numero: rand(100),
                                                          quota: rand(10.00..500.00),
                                                          servizio:contributions_servizio)}
  end
end