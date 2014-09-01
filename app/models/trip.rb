class Trip < ActiveRecord::Base
  has_many :medias
  belongs_to :user
end
