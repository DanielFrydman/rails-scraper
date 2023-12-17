FactoryBot.define do
  factory :scraped_info do
    url { Faker::Internet.url }
    data {
      {
        'price' => '18290,-',
        'rating_value' => '4,9',
        'rating_count' => '7 hodnocení',
        'meta' => {
          'keywords' => 'Parní pračka AEG 7000 ProSteam® LFR73964CC na www.alza.cz. ✅Bezpečný nákup. ✅ Veškeré informace o produktu. ✅ Vhodné příslušenství. ✅ Hodnocenía recenze AEG...',
          'twitter:image' => 'https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360'
        }
      }
    }
  end
end

