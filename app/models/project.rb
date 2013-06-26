# == Schema Information
#
# Table name: projects
#
#t.integer  "user_id"
#t.datetime "created_at",     :null => false
#t.datetime "updated_at",     :null => false
#t.string   "titolo"
#t.string   "descrizione"
#t.string   "categoria"
#t.datetime "data_creazione"
#t.datetime "data_fine"
#t.string   "tags"
#t.string   "images"
#t.string   "videos"
#t.float    "budget_attuale"
#t.float    "goal"
#t.string   "img_copertina"
#t.string   "risorse_umane"
#t.string   "gift"
#

class Project < ActiveRecord::Base
  # only content must be accessible, in order to avoid manual (and wrong) associations between posts and users
  attr_accessible :titolo, :descrizione, :categoria, :data_creazione, :data_fine,:tags, :images, :videos, :budget_attuale, :goal, :img_copertina, :risorse_umane, :gift ,:luogo

  has_many :contributions, dependent: :destroy

  # each projects belong to a specific user
  belongs_to :user

  # descending order for getting the projects
  default_scope order: 'projects.created_at DESC'

  # user_id must be present while creating a new project...

  validates :user_id, presence: true

  # titolo must be present and not longer than 100 chars
  validates :titolo, presence: true, length: {maximum: 100}

  validates :descrizione, :categoria, :data_creazione, :data_fine,:tags, :goal,:luogo, presence: true

  # get user's projects plus all the projects written by her followed users
  def self.from_users_followed_by(user)
    followed_user_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end

  def self.search(search)
    if search
      where('titolo LIKE ? or categoria LIKE ? or luogo LIKE ? or tags LIKE ?', "%#{search}%","%#{search}%","%#{search}%","%#{search}%")
    else
      scoped # return an empty result set
    end
  end

end
