require 'spec_helper'

# describe AdUnitBot do
#   it 'has a version number' do
#     expect(AdUnitBot::VERSION).not_to be nil
#   end

#   it 'does something useful' do
#     expect(false).to eq(true)
#   end
# end

describe AdUnitBot do

  # subject(:ad_unit) do
  #   AdUnitBot.new('un', 'pw')
  # end
  after { Capybara.reset_sessions! }

  let(:email) { 'tanuwkanov@yandex.ru' }
  let(:password) { '123456q' }
  let(:platform_id) { '300029472' }

  it "logs in with valid credentials" do
    unit = AdUnitBot.new('tanuwkanov@yandex.ru', '123456q', 1)
    expect { unit.login }.to_not raise_error
  end

  context "logs in with invalid credentials" do
    let(:email) { "dizwarhomo" }
    let(:password)     { "homohomo" }

    it "raises LoginFailed" do
      unit = AdUnitBot.new('dizwarhomo@ert.ty', 'homohomo', 2)
      expect { unit.login }.to raise_error(RuntimeError)
    end
  end

  it "verifies a platform is valid" do
    unit = AdUnitBot.new('tanuwkanov@yandex.ru', '123456q', 2)
    expect(unit.verifies_platform?('10165')).to be_truthy 
  end

  it "platform is not found" do
    unit = AdUnitBot.new('tanuwkanov@yandex.ru', '123456q', 3)
    expect { unit.choose_platform('fail') }.to raise_error("Platform id is not found.")
  end

  it "creates ad unit" do
    unit = AdUnitBot.new('tanuwkanov@yandex.ru', '123456q', 112)
    unit.create_ad_unit('10165')
    expect { unit.created_new_ad_unit('111') }.to_not raise_error
  end

  it "new ad unit did not create" do
    unit = AdUnitBot.new('tanuwkanov@yandex.ru', '123456q', 112)
    unit.create_ad_unit('10165')
    expect { unit.created_new_ad_unit('113') }.to raise_error("New ad unit not found")
  end
end
