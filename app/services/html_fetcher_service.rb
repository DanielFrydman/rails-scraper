# frozen_string_literal: true

require 'faraday'

class HtmlFetcherService
  NOT_AUTHORIZED_TOKEN = 'AUTH'.freeze

  def initialize
    @proxy = "http://#{Rails.application.config.proxy_key}:js_render=true&antibot=true@proxy.zenrows.com:8001"
  end

  def fetch(url:)
    connection = Faraday.new(proxy: @proxy, ssl: { verify: false })
    connection.options.timeout = 180
    response = connection.get(url, nil, nil)
    @response_body = response.body
    raise_not_authorized_error if connection_not_authorized?

    @response_body
  rescue StandardError => e
    raise_html_fetcher_exception(e)
  end

  private

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
