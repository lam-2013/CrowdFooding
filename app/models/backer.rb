class Backer < ActiveRecord::Base
  attr_accessible :contribution_id, :user_id

  validates :contribution_id, :user_id, presence: true


  default_scope order: 'user_id.created_at DESC'
end
