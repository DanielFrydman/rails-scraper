# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(HtmlFetcherService, type: :service) do
  describe '#fetch' do
    before do
      stub_const('APP_CONFIG::PROXY_KEY', 'randon-key')
      Rails.application.config.redis.flushall
    end

    subject { described_class.new.fetch(url: 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm') }

    context 'when everything goes well' do
      it 'returns the html' do
        VCR.use_cassette('html_fetcher_service/success') do
          expect(subject).to(include('html'))
        end
      end
    end

    context 'when something goes wrong' do
      context 'when we use an invalid api key' do
        it 'raises error' do
          VCR.use_cassette('html_fetcher_service/non_authorized') do
            expect do
              subject
            end.to(
              raise_error(
                HtmlFetcherException,
                'An error occurred while trying to fetch the HTML: The apikey ' \
                'sent does not match the expected format. The apikey must match ' \
                'the following regular expression: /^[0-9][a-f]{40}$/'
              )
            )
          end
        end
      end

      context 'when a standard error occurs' do
        let(:faraday_double) { double('faraday') }

        before do
          stub_const('Faraday', faraday_double)
          allow(faraday_double).to(receive(:new)).and_return(faraday_double)
          allow(faraday_double).to(receive(:options)).and_return(faraday_double)
          allow(faraday_double).to(receive(:timeout=)).and_return(faraday_double)
          allow(faraday_double).to(receive(:get)).and_raise(StandardError, 'Something went wrong!')
        end

        it 'raises error' do
          expect do
            subject
          end.to(raise_error(HtmlFetcherException,
                             'An error occurred while trying to fetch the HTML: Something went wrong!'))
        end
      end
    end
  end
end
