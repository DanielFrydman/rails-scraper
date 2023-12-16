# frozen_string_literal: true

Rails.application.config.redis_create = lambda do
  if Rails.env.test?
    db = ((ENV['TEST_ENV_NUMBER'].presence || '1').to_i - 1)
    url = ENV.fetch('REDIS_TEST_URL', 'redis://localhost:6380')
  else
    db = 0
    url = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
  end

  Redis.new(
    url: url,
    db: db,
    timeout: nil,
    reconnect_attempts: nil
  )
end

Rails.application.config.redis = Rails.application.config.redis_create.call
