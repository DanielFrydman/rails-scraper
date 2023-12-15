# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(HtmlFetcherService, type: :service) do
  describe '#fetch' do
    before do
      allow(Rails.application.config).to(receive(:proxy_key)).and_return('randon-key')
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
        it 'returns non authorized json' do
          VCR.use_cassette('html_fetcher_service/non_authorized') do
            response = JSON.parse(subject)
            expect(response['code']).to(eq('AUTH002'))
            expect(response['detail']).to(include('The apikey sent does not match the expected format.'))
          end
        end
      end

      context 'when standard error occurs' do
        let(:faraday_double) { double('faraday') }

        before do
          stub_const('Faraday', faraday_double)
          allow(faraday_double).to(receive(:new)).and_raise(StandardError, 'Some random error')
        end

        it 'raises error' do
          expect {
            subject
          }.to(raise_error(HtmlFetcherException, 'An error occurred while trying to fetch the HTML: Some random error'))
        end
      end
    end
  end
end
