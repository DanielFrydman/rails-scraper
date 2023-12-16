# frozen_string_literal: true

Rails.application.config.redis = Redis.new(
  url: APP_CONFIG::REDIS_URL,
  db: 0,
  timeout: nil,
  reconnect_attempts: nil
)
