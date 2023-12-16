# frozen_string_literal: true

CONFIG = if Rails.env.production?
           YAML.load_file(Rails.root.join('app.yml'))[Rails.env]
         else
           YAML.load_file(Rails.root.join('config/app.yml'))[Rails.env]
         end

module APP_CONFIG
  PROXY_KEY = CONFIG['proxy_key']
  REDIS_URL = CONFIG['redis_url']
end
