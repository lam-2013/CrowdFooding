class Contribution < ActiveRecord::Base
  attr_accessible :numero, :quota, :servizio

  belongs_to :projects

  default_scope order: 'contributions.created_at DESC'

  validates :project_id, presence: true

  validates :numero, :quota, presence: true
  validates :servizio, presence: true, length: {minimum: 20}


end
