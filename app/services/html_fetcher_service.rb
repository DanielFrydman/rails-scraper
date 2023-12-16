# frozen_string_literal: true

require 'faraday'

class HtmlFetcherService
  NOT_AUTHORIZED_TOKEN = 'AUTH'.freeze
  CACHE_EXPIRATION_TIME = 30.minutes
  TIME_NEEDED_TO_THE_PROXY_WORK_CORRECTLY = 180.freeze

  def initialize
    @cache = Rails.application.config.redis
    initialize_connection
  end

  def fetch(url:)
    cached_html = @cache.get(url)
    return cached_html if cached_html.present?

    @response_body = @connection.get(url, nil, nil).body
    raise_not_authorized_error if connection_not_authorized?
  
    @cache.setex(url, CACHE_EXPIRATION_TIME, @response_body)
    @response_body
  rescue StandardError => e
    raise_html_fetcher_exception(e)
  end

  private

  def initialize_connection
    @connection = Faraday.new(
      proxy: "http://#{APP_CONFIG::PROXY_KEY}:js_render=true&antibot=true@proxy.zenrows.com:8001",
      ssl: { verify: false }
    )
    @connection.options.timeout = TIME_NEEDED_TO_THE_PROXY_WORK_CORRECTLY
  end

  def raise_not_authorized_error
    parsed_body = JSON.parse(@response_body)
    raise(StandardError, parsed_body['detail'])
  end

  def raise_html_fetcher_exception(e)
    raise(HtmlFetcherException, e.message)
  end

  def connection_not_authorized?
    @response_body.include?(NOT_AUTHORIZED_TOKEN)
  end
end
