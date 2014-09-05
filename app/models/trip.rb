class Trip < ActiveRecord::Base
  has_many :medias
  belongs_to :user

  validates :title, :description, :date_start, :date_end,
            :presence => true
end
