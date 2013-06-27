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
  numeri=['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
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
    email = Faker::Internet.email(name)
    sito_web= Faker::Internet.url
    password  = "password"
    numero_copertina = numeri[r.rand(numeri.size)]
    user_luogo = city[r.rand(city.size)]
    User.create!(name: name,
                 cognome:cognome,
                 email: email,
                 luogo: user_luogo,
                 sito_web: sito_web,
                 sesso: sesso[r.rand(sesso.size)],
                 descrizione:user_descrizione,
                 img_copertina: "copertine_users/copertina"<<numero_copertina<<".jpg",
                 nascita: time_rand(Time.now-80.years,Time.now-18.years),
                 password: password,
                 password_confirmation: password)
  end
end

def make_projects


  # generate 10 fake projects for the all users
  city=["Torino","Milano","Bologna","Palermo","Genova","Roma"]
  categoria=["ARTE & TEMPO LIBERO","STILE DI VITA & TECNOLOGIA","SOCIAL INNOVATION","EVENTI","CIBO"]
  budget=[10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,1000,1500,2000,2500,3000,3500,4000]
  goal=[100,200,300,400,500,600,700,1000,1500,2000]
  videos=["http://www.youtube.com/watch?v=-38uPkyH9vI","http://www.youtube.com/watch?v=3lQoe9GlYWU","http://www.youtube.com/watch?v=OI-bTpbkH4Y"]
  images= 'http://www.nexusedizioni.it/ambiente-e-salute/files/2013/06/frutta.jpg,http://3.bp.blogspot.com/_yst0qSwAzA0/S8mEDyKs28I/AAAAAAAAA24/XTn2b6ohixU/s1600/3471645952_b34ecf3583.jpg,http://www.teknemedia.net/magazine/esposizioni/2008/TKmag4933badb0647f.jpg,http://www.luxury24.ilsole24ore.com/IMMAGINI/EcoCharity/2009/04/Vicissitudes-352x288.jpg?uuid=42180d62-25db-11de-9461-d9514a44e445,http://www.greenews.info/wp-content/uploads/2009/12/Courtesy-of-Farm4static-Flickr.jpg,http://www.mentelocale.it/images/articoli/full/49132-1.jpg,http://sibari.mareblog.com/files/2010/01/slow_food.jpg,http://m2.paperblog.com/i/62/621399/fairtrade-ed-equosolidale-per-bambini-L-BUrYy3.jpeg'
  numeri=['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
  r = Random.new
  users = User.all
  10.times do

    users.each { |user|

      project_titolo = Faker::Lorem.sentence(1)
      project_descrizione = Faker::Lorem.sentence(20)
      project_luogo = city[r.rand(city.size)]
      project_categoria = categoria[r.rand(categoria.size)]
      contributions_servizio = Faker::Lorem.sentence(2)
      project_goal = goal[r.rand(goal.size)]
      video = videos[r.rand(videos.size)]
      project_budget_attuale = budget[r.rand(budget.size)]
      project_tags = ["festa","cibo","coltivazione","costruzione","cultura","terra","piante","agricoltura","mare","sagra","cucina"]

      tag = project_tags[r.rand(project_tags.size)]

      project_data_creazione = time_rand Time.local(2013, 5, 20), Time.now
      project_data_fine = project_data_creazione + 4.week
      numero_copertina = numeri[r.rand(numeri.size)]
      user.projects.create!(titolo: project_titolo,
                            luogo: project_luogo,
                            descrizione: project_descrizione,
                            categoria: project_categoria,
                            img_copertina: "copertine_projects/copertina"<<numero_copertina<<".jpg",
                            videos: video,
                            tags: tag,
                            images: images,
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
  users = User.all
  users.each { |user|

  r.rand(2..15).times do
    Backer.create!(contribution_id: r.rand(1..2500), user_id: user.id)
  end
  }
end