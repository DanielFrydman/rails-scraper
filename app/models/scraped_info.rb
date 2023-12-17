class ScrapedInfo < ApplicationRecord
  validates :url, :data, presence: true
end
