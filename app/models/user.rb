# == Schema Information
#
# Table name: users
#
#t.string   "name"
#t.string   "email"
#t.datetime "created_at",                         :null => false
#t.datetime "updated_at",                         :null => false
#t.string   "password_digest"
#t.string   "remember_token"
#t.boolean  "admin",           :default => false
#t.string   "cognome"
#t.string   "sesso"
#t.date     "nascita"
#t.string   "luogo"
#t.string   "img_copertina"
#t.string   "descrizione"
#t.string   "sito_web"
#t.string   "occupazione"
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :cognome, :sesso, :nascita, :luogo, :img_copertina, :descrizione, :sito_web, :occupazione, :facebook_uid, :twitter_uid


  # basically, the method realizes the authentication system
  has_secure_password

  # each user can have some posts associated and they must be destroyed together with the user
  has_many :projects, dependent: :destroy

  # each user can have many relationships
  # we need to explicitly define a foreign key since, otherwise, Rails looks for a relationship_id column (that not exists)
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy

  # each user can have many followed users, through the relationships table
  # since followed_users does not exist, we need to give to Rails the right column name in the relationships column (with source: "followed_id")
  has_many :followed_users, through: :relationships, source: :followed

  # each user can have many "reverse" relationships (by inverse reading the Relationship model)
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy

  # each user can have many followers, through reverse relationships
  has_many :followers, through: :reverse_relationships

  # put the email in downcase before saving the user
  before_save { |user| user.email = email.downcase }
  # call the create_remember_token private method before saving the user
  before_save :create_remember_token

  # name must be always present and with a maximum length of 50 chars
  validates :name, presence: true, length: { maximum: 50 };

  # email allowed format representation (expressed as a regex)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i

  # email must be always present, unique and with a specific format
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # password must be always present, and with a minimum length of 6 chars
  validates :password, presence: true, length: { minimum: 6 }

  # password_confirmation must be always present
  validates :password_confirmation, presence: true

  # is the current user following the given user?
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  # follow a give user
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # unfollow a given user
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  # get the projects to show in the wall
  def feed
    Project.from_users_followed_by(self)
  end

  # get the searched user(s) by (part of her) name
  def self.search(user_name)
    if user_name
      where('name LIKE ?', "%#{user_name}%")
    else
      scoped # return an empty result set
    end
  end

  # private methods
  private

    def create_remember_token
      # create a random string, safe for use in URIs and cookies, for the user remember token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
