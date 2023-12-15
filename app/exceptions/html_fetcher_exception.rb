class HtmlFetcherException < StandardError
  def initialize(error_message)
    super("An error occurred while trying to fetch the HTML: #{error_message}")
  end
end
