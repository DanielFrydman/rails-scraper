# frozen_string_literal: true

class WebPageScraperException < StandardError
  def initialize(error_message)
    super("An error occurred while trying to scrape the HTML: #{error_message}")
  end
end
