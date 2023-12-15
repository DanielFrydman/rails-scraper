# frozen_string_literal: true

Rails.application.config.proxy_key = ENV.fetch('PROXY_KEY', '')
