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
  let(:email_user) { 'tanuwkanov@yandex.ru' }
  let(:password) { '123456q' }

  it "logs in with valid credentials" do
    expect { AdUnitBot.headlessly_login }.to_not raise_error
  end

  context "logs in with invalid credentials" do
    let(:account_user) { "dizwarhomo" }
    let(:password)     { "homohomo" }

    it "raises LoginFailed" do
      expect { AdUnitBot.headlessly_login }.to raise_error "Invalid login or password"
    end
  end
end
