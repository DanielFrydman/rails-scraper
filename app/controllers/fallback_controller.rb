# frozen_string_literal: true

class FallbackController < ActionController::Base
  def index
    render file: 'public/index.html'
  end
end
