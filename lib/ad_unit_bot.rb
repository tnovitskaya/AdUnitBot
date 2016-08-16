require 'headless'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium

class AdUnitBot
  include Capybara::DSL

  WAIT = Selenium::WebDriver::Wait.new(:timeout => 30)
  SHOW_LIMIT = 'Лимит показов уникальному пользователю'
  CREATE_BLOCK_BTN_TEXT = 'Создать блок'
  ENTER_BTN_TEXT = 'Войти'
  SITE_URL = 'http://target.my.com/'

  def initialize(email, password, platform_id)
    @email = email
    @password = password
    @platform_id = platform_id
  end

  def login
    visit SITE_URL

    process_after_visit_site
    raise 'Invalid login or password' unless logged_in?
  end

  def platform_exists?
    choose_platform
    WAIT.until { has_link?(CREATE_BLOCK_BTN_TEXT) }
    find(:xpath, "//a[contains(@href, '#{@platform_id}/edit')]")
  end

  def choose_platform
    visit SITE_URL
    process_after_visit_site if has_xpath?(enter_path)

    WAIT.until { has_link?('Создать площадку') }
    begin
      platform = find(:xpath, "//a[contains(@href, '#{@platform_id}')]")
    rescue Capybara::ElementNotFound
      raise 'Platform id is not found.'
    end

    platform.click
  end

  def create_ad_unit(block_params = {})
    platform_exists?
    click_on(CREATE_BLOCK_BTN_TEXT)
    WAIT.until { has_content?('Типы блоков') }
    fill_ad_unit_params(block_params)

    find(:xpath, "//span[text()='Добавить блок']").click
  end

  private

  def process_after_visit_site
    WAIT.until { has_xpath?(enter_path) }
    find(:xpath, enter_path).click

    fill_in 'Email или телефон', with: @email
    fill_in 'Пароль', with: @password

    WAIT.until { has_button? (ENTER_BTN_TEXT) }
    click_button (ENTER_BTN_TEXT)
  end

  def logged_in?
    path = "//span[text()='#{@email}']"
    WAIT.until { has_xpath?(path) || 
                  has_content?('Invalid login or password')}
    has_xpath?(path)
  end

  def select_block_params(title, block_params = {})
    param = find(:xpath, "//li[span[contains(text(), '#{title}')]]/" +
                         "select/option[.='#{block_params}']")
    param.select_option
  end

  def enter_path
    "//span[text()='#{ENTER_BTN_TEXT}']"
  end

  def fill_ad_unit_params(block_params = {})
    fill_in 'Назовите ваш блок', with: block_params[:title]
    find(:xpath, "//span[text()='#{block_params[:type]}']").click

    unless has_content?(SHOW_LIMIT)
      find(:xpath, "//div[span[text()='Частота показов:']]").click
    end

    select_block_params(SHOW_LIMIT, block_params[:show_limit])
    select_block_params('за период', block_params[:period])
    select_block_params('Интервал между показами', block_params[:interval])
  end
end
