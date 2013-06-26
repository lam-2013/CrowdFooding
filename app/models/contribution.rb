class Contribution < ActiveRecord::Base
  attr_accessible :numero, :quota, :servizio, :project_id

  belongs_to :projects
  has_one :project

  default_scope order: 'contributions.quota, contributions.project_id  DESC'

  validates :project_id, presence: true
  validates :numero, :quota, presence: true
  validates :servizio, presence: true, length: {minimum: 5}


end
