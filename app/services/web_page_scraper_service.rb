# frozen_string_literal: true

require 'nokogiri'

class WebPageScraperService
  def initialize(url:, meta_tags: [], css_selector_fields: {})
    @url = url
    @meta_tags = meta_tags
    @css_selector_fields = css_selector_fields
    @elements = {}
    @html_fetcher_service = HtmlFetcherService.new
  end

  def scrape
    html = @html_fetcher_service.fetch(url: @url)
    document = Nokogiri::HTML(html)

    get_elements_from_css_selector_fields(document)
    get_elements_from_meta_tags(document)
    save_scraped_data

    @elements
  rescue HtmlFetcherException => e
    raise e
  rescue StandardError => e
    raise_web_page_scraper_exception(e)
  end

  private

  def save_scraped_data
    ScrapedInfo.create!(
      url: @url,
      data: @elements
    )
  rescue StandardError => e
    raise("Scraped information not saved because #{e}")
  end

  def get_elements_from_css_selector_fields(document)
    @css_selector_fields.each do |key, value|
      element = document.css(value).text
      @elements[key.to_s] = element
    end
  end

  def get_elements_from_meta_tags(document)
    @meta_tags.each do |meta_tag|
      @elements['meta'] ||= {}
      element = document.css("meta[name^=\"#{meta_tag}\"]").first&.values&.last
      @elements['meta'][meta_tag] = element
    end
  end

  def raise_web_page_scraper_exception(error)
    raise(WebPageScraperException, error.message)
  end
end
