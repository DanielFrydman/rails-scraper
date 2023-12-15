# frozen_string_literal: true

module V1
  class ScraperController < ApplicationController
    def index
      service = WebPageScraperService.new(
        url: url,
        meta_tags: meta_tags,
        css_selector_fields: css_selector_fields
      )

      render json: { result: service.scrape }, status: :ok
    rescue WebPageScraperException,
           HtmlFetcherException => e
      render json: { error: e }, status: :bad_request
    rescue StandardError => e
      render json: { error: e }, status: :internal_server_error
    end

    private

    def url
      params.require(:scraper).require(:url)
    end

    def meta_tags
      fields[:meta].to_a
    end

    def css_selector_fields
      fields.except(:meta).to_h
    end

    def fields
      params.require(:scraper).permit(fields: {})[:fields]
    end
  end
end
