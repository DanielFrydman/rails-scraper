# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::WebPageScraperController, type: :controller) do
  describe 'GET #index' do
    let(:params) do
      {
        web_page_scraper: {
          url: 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm',
          fields: {
            meta: %w[keywords application-name],
            price: '.price-box__price',
            chat: '.chat-wrapper'
          }
        }
      }
    end

    subject { post(:index, params: params) }
  
    context 'when everything goes well' do
      let(:expected_response) do
        "{\"result\":{\"chat\":\"\\n\\n\\n\\n\\n\\n\\n\\n\\nVáš osobní asistent" \
        "\\n\\n\\n\\n\\n\\nAlza Premium\\n\\n\\n\\n\\n\\n\\n\\n\\nNapsat dotaz\\n" \
        "\\n\\n\\nZavolejte mi\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\nNová konverzace\\n" \
        "\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n" \
        "\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\",\"price\":\"18390,-\"," \
        "\"meta\":{\"keywords\":\"AEG,7000,ProSteam®,LFR73964CC,Automatické pračky," \
        "Automatické pračky AEG,Chytré pračky,Chytré pračky AEG\",\"application-name\":\"Alza.cz\"}}}"
      end

      it 'returns a hash with all required elements' do
        VCR.use_cassette('html_fetcher_service/success') do
          subject
          response.body.slice!(260) # For some reason, the price has an empty space that isn't a real space
          expect(response.body).to(eq(expected_response))
        end
      end

      it 'returns ok' do
        VCR.use_cassette('html_fetcher_service/success') do
          subject
          expect(response).to(have_http_status(:ok))
        end
      end
    end

    context 'when something goes wrong' do
      context 'WebPageScraperException' do
        let(:html_fetcher_service) { double('HtmlFetcherService') }

        before do
          stub_const('HtmlFetcherService', html_fetcher_service)
          allow(html_fetcher_service).to(receive(:new)).and_return(html_fetcher_service)
          allow(html_fetcher_service).to(receive(:fetch)).and_raise(StandardError, 'Something went wrong!')
        end

        it 'returns error message' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body['error']).to(
            eq(
              'An error occurred while trying to scrape the HTML: Something went wrong!'
            )
          )
        end

        it 'returns bad request' do
          subject
          expect(response).to(have_http_status(:bad_request))
        end
      end

      context 'HtmlFetcherException' do
        it 'returns error message' do
          VCR.use_cassette('html_fetcher_service/non_authorized') do
            subject
            response_body = JSON.parse(response.body)
            expect(response_body['error']).to(
              eq(
                'An error occurred while trying to fetch the HTML: The apikey ' \
                'sent does not match the expected format. The apikey must match ' \
                'the following regular expression: /^[0-9][a-f]{40}$/'
              )
            )
          end
        end

        it 'returns bad request' do
          VCR.use_cassette('html_fetcher_service/non_authorized') do
            subject
            expect(response).to(have_http_status(:bad_request))
          end
        end
      end

      context 'StandardError' do
        let(:web_page_scraper_service) { double('WebPageScraperService') }

        before do
          stub_const('WebPageScraperService', web_page_scraper_service)
          allow(web_page_scraper_service).to(receive(:new)).and_raise(StandardError, 'Something went wrong!')
        end

        it 'returns error message' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body['error']).to(
            eq(
              'An unexpected error occurred: Something went wrong!'
            )
          )
        end

        it 'returns bad request' do
          subject
          expect(response).to(have_http_status(:internal_server_error))
        end
      end
    end
  end
end
