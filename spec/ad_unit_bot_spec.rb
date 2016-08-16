require 'spec_helper'

include AdUnitBotHelpers

describe AdUnitBot do

  subject(:unit) { AdUnitBot.new(email, password, platform_id) }

  after { Capybara.reset_sessions! }

  let(:email) { 'iwanowa.te2017@yandex.ru' }
  let(:password) { '123456t' }
  let(:platform_id) { '10239' }

  let(:block_params) { { title: Faker::Crypto.md5,
                         type: ['standard', 'medium', 'fullscreen',
                                'floating', 'native'].sample,
                         show_limit: Faker::Number.between(1, 31),
                         period: ['в день', 'в неделю', 'в месяц',
                                  'за всё время'].sample,
                         interval: Faker::Number.between(1, 31) } }

  it 'logs in with valid credentials' do
    expect { unit.login }.to_not raise_error
  end

  context 'when logs in with invalid credentials' do
    let(:email)    { 'not_existing@email.com' }
    let(:password) { 'invalid_password' }

    it 'raises LoginFailed' do
      expect { unit.login }.to raise_error('Invalid login or password')
    end
  end

  it 'verifies a platform is valid' do
    expect(unit.platform_exists?).to be_truthy
  end

  context 'when platform does not exists' do
    let(:platform_id) { 'fail' }

    it 'platform is not found' do
      expect { unit.choose_platform }
        .to raise_error('Platform id is not found.')
    end
  end

  it 'creates new ad unit' do
    unit.create_ad_unit(block_params)
    expect { unit.created_new_ad_unit(block_params) }.to_not raise_error
  end
end
