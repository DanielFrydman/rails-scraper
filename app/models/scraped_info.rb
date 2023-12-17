# frozen_string_literal: true

class ScrapedInfo < ApplicationRecord
  validates :url, :data, presence: true
end
