namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    make_users
    make_projects
    make_contributions
    make_relationships
    make_backers

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
  49.times do |n|
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
                 nascita: time_rand(Time.now-80.years,Time.now-18.years),
                 password: password,
                 password_confirmation: password)
  end
end

def make_projects


  # generate 10 fake projects for the all users
  city=["Torino","Milano","Bologna","Palermo","Genova","Roma"]
  categoria=["ART & ENTERTAINMENT","LIFESTYLE & TECHNOLOGY","SOCIAL INNOVATION","EVENTI","FOOD"]
  budget=[10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,1000,1500,2000,2500,3000,3500,4000]
  goal=[100,200,300,400,500,600,700,1000,1500,2000]
  videos=["http://www.youtube.com/watch?v=-38uPkyH9vI","http://www.youtube.com/watch?v=3lQoe9GlYWU","http://www.youtube.com/watch?v=OI-bTpbkH4Y"]
  r = Random.new
  users = User.all
  10.times do

    users.each { |user|

      project_titolo = Faker::Lorem.words(2)
      project_descrizione = Faker::Lorem.sentence(20)
      project_luogo = city[r.rand(city.size)]
      project_categoria = categoria[r.rand(categoria.size)]
      contributions_servizio = Faker::Lorem.sentence(2)
      project_goal = goal[r.rand(goal.size)]
      video = videos[r.rand(videos.size)]
      project_budget_attuale = budget[r.rand(budget.size)]
      project_tags = '1,2,3,4,5'
      project_data_creazione = time_rand Time.local(2013, 6, 1), Time.now
      project_data_fine = project_data_creazione + 2.week

      user.projects.create!(titolo: project_titolo,
                            luogo: project_luogo,
                            descrizione: project_descrizione,
                            categoria: project_categoria,
                            img_copertina: 'copertine_projects'.concat('/copertina1.jpg'),
                            videos: video,
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
  followed_users = users[2..100]
  followers = users[3..80]
  # first user follows user 3 up to 51
  followed_users.each { |followed| user.follow!(followed) }
  # users 4 up to 41 follow back the first user
  followers.each { |follower| follower.follow!(user) }
end


def time_rand from = Time.now - 80.years, to = Time.now - 18.years
  Time.at(from + rand * (to.to_f - from.to_f))
end


def make_contributions
  r = Random.new
  numero=[10,20,50,100]
  quota=[10,20,30,50,100,200,300,400,500]
  projects = Project.all
  5.times do
    contributions_servizio = Faker::Lorem.sentence(5)
    projects.each { |project| project.contributions.create!(numero: numero[r.rand(numero.size)],
                                                            quota: quota[r.rand(quota.size)],
                                                            servizio:contributions_servizio)}
  end
end


def make_backers
  r = Random.new
  100.times do
    Backer.create!(contribution_id: r.rand(1..2500), user_id: r.rand(1..100))
  end
end