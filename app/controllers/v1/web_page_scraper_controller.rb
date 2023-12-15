# frozen_string_literal: true

module V1
  class WebPageScraperController < ApplicationController
    def index
      service = WebPageScraperService.new(
        url:,
        meta_tags:,
        css_selector_fields:
      )

      render json: { result: service.scrape }, status: :ok
    rescue WebPageScraperException,
           HtmlFetcherException => e
      render json: { error: e }, status: :bad_request
    rescue StandardError => e
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end

    private

    def meta_tags
      fields[:meta].to_a
    end

    def css_selector_fields
      fields.except(:meta).to_h
    end

    def fields
      web_page_scraper_params.permit(fields: {})[:fields]
    end

    def url
      web_page_scraper_params.require(:url)
    end

    def web_page_scraper_params
      params.require(:web_page_scraper)
    end
  end
end
