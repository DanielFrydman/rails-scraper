require 'faraday'

class HtmlFetcherService
  def initialize
    @proxy = "http://#{Rails.application.config.proxy_key}:js_render=true&antibot=true@proxy.zenrows.com:8001"
  end

  def fetch(url:)
    connection = Faraday.new(proxy: @proxy, ssl: { verify: false })
    connection.options.timeout = 180
    response = connection.get(url, nil, nil)
    response.body
  rescue StandardError => e
    raise_html_fetcher_exception(e)
  end

  private

  def raise_html_fetcher_exception(e)
    raise(HtmlFetcherException, e.message)
  end
end
