# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapedInfo, type: :model do
  subject { FactoryBot.create(:scraped_info, url: Faker::Internet.url, data: { 'price' => '18290,-' }) }

  it 'is valid with valid attributes' do
    expect(subject).to(be_valid)
  end

  it 'is not valid without a URL' do
    subject.url = nil
    expect(subject).to_not(be_valid)
  end

  it 'is not valid without a DATA' do
    subject.data = nil
    expect(subject).to_not(be_valid)
  end
end
