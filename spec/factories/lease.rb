FactoryGirl.define do
  factory :lease do
    association :lead_source
    cid "whatisacid"
    status "active"
  end
end
