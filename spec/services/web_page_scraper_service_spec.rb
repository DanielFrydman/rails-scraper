# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(WebPageScraperService, type: :service) do
  describe '#scrape' do
    before do
      allow(Rails.application.config).to(receive(:proxy_key)).and_return('randon-key')
    end

    subject do
      described_class.new(
        url: 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm',
        meta_tags: %w[keywords application-name],
        css_selector_fields: {
          'price' => '.price-box__price',
          'chat' => '.chat-wrapper'
        }
      ).scrape
    end

    context 'when everything goes well' do
      let(:price_excpectation) { '18390,-' }
      let(:application_name_excpectation) { 'Alza.cz' }
      let(:chat_excpectation) do
        "\n\n\n\n\n\n\n\n\nVáš osobní asistent\n\n\n\n\n\nAlza Premium" \
          "\n\n\n\n\n\n\n\n\nNapsat dotaz\n\n\n\nZavolejte mi\n\n\n\n\n\n" \
          "\n\n\n\n\nNová konverzace\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" \
          "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
      end
      let(:keywords_excpectation) do
        'AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,Automatické pračky ' \
          'AEG,Chytré pračky,Chytré pračky AEG'
      end
      let(:meta_hash_excpectation) do
        {
          'keywords' => 'AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,' \
                        'Automatické pračky AEG,Chytré pračky,Chytré pračky AEG',
          'application-name' => 'Alza.cz'
        }
      end

      it 'returns a hash with all required elements' do
        VCR.use_cassette('html_fetcher_service/success') do
          hash = subject
          meta_hash = hash['meta']
          expect(hash).to(have_key('meta'))
          expect(hash).to(have_key('price'))
          expect(hash).to(have_key('chat'))
          expect(meta_hash).to(have_key('keywords'))
          expect(meta_hash).to(have_key('application-name'))
        end
      end

      it 'returns a hash with all required values' do
        VCR.use_cassette('html_fetcher_service/success') do
          hash = subject
          meta_hash = hash['meta']
          hash['price'].slice!(2) # For some reason, the price has an empty space that isn't a real space
          expect(hash['price']).to(eq(price_excpectation))
          expect(hash['chat']).to(eq(chat_excpectation))
          expect(meta_hash['keywords']).to(eq(keywords_excpectation))
          expect(meta_hash['application-name']).to(eq(application_name_excpectation))
          expect(meta_hash).to(eq(meta_hash_excpectation))
        end
      end
    end

    context 'when something goes wrong' do
      context 'when we use an invalid api key' do
        it 'returns non authorized json' do
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

      context 'when an error occurs with html fetcher service' do
        let(:faraday_double) { double('faraday') }

        before do
          stub_const('Faraday', faraday_double)
          allow(faraday_double).to(receive(:new)).and_raise(StandardError, 'Something went wrong!')
        end

        it 'raises error' do
          expect do
            subject
          end.to(
            raise_error(
              HtmlFetcherException,
              'An error occurred while trying to fetch the HTML: Something went wrong!'
            )
          )
        end
      end

      context 'when a standard error occurs' do
        let(:html_fetcher_service) { double('HtmlFetcherService') }

        before do
          stub_const('HtmlFetcherService', html_fetcher_service)
          allow(html_fetcher_service).to(receive(:new)).and_return(html_fetcher_service)
          allow(html_fetcher_service).to(receive(:fetch)).and_raise(StandardError, 'Something went wrong!')
        end

        it 'raises error' do
          expect do
            subject
          end.to(
            raise_error(
              WebPageScraperException,
              'An error occurred while trying to scrape the HTML: Something went wrong!'
            )
          )
        end
      end
    end
  end
end
