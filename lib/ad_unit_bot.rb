require "ad_unit_bot/version"
require 'rubygems'
require 'headless'
require 'selenium-webdriver'
require 'capybara'
require 'byebug'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium

class AdUnitBot
  include Capybara::DSL
  include RSpec::Matchers
  WAIT = Selenium::WebDriver::Wait.new(:timeout => 30)

  def initialize(email, password, title)
    @email = email
    @password = password
    @title = title
  end

  def login
    visit "http://target.my.com/"

    process_after_visit_site
    raise "Invalid login or password" unless logged_in?
  end

  def choose_platform(platform_id)
    visit "http://target.my.com/"
    process_after_visit_site
    WAIT.until { has_link?("Создать площадку") }
    begin
      platform = find(:xpath, "//a[contains(@href, '#{platform_id}')]")
    rescue Capybara::ElementNotFound
      raise "Platform id is not found."
    end

    platform.click
  end

  def verifies_platform?(platform_id)
    choose_platform(platform_id)
    WAIT.until { has_link?("Создать блок") }
    find(:xpath, "//a[contains(@href, '#{platform_id}/edit')]")
  end

  def create_ad_unit(platform_id)
    verifies_platform?(platform_id)
    click_on("Создать блок")
    WAIT.until { has_content?("Типы блоков") }
    fill_in 'Назовите ваш блок', with: @title
    type = find(:xpath, "//span[text()='medium']")
    type.click
    show = find(:xpath, "//div[span[text()='Частота показов:']]") unless
      has_content? ("Лимит показов уникальному пользователю")
    show.click
    select_limit
    select_period
    select_interval
    new_unit
  end

  def select_limit
    as = find(:xpath, "//li[span[contains(text(), 'Лимит показов уникальному пользователю')]]/select/option[.='1']")
    as.select_option
  end

  def select_period
    as = find(:xpath, "//li[span[contains(text(), 'за период')]]/select/option[.='в неделю']")
    as.select_option
  end

  def select_interval
    as = find(:xpath, "//li[span[contains(text(), 'Интервал между показами')]]/select/option[.='3']")
    as.select_option
  end

  def new_unit
    new_unit_button = find(:xpath, "//span[text()='Добавить блок']")
    new_unit_button.click
  end

  def created_new_ad_unit(title)
    WAIT.until { has_link?("Создать блок") }
    ad_unit = find(:xpath, "//table/tbody/tr/td/div/a[text()='#{title}']")
  rescue Capybara::ElementNotFound
    raise "New ad unit not found" 
  end

  private

  def process_after_visit_site
    WAIT.until { has_xpath?("//span[text()='Войти']") }
    auth_button = find(:xpath, "//span[text()='Войти']")
    auth_button.click

    fill_in 'Email или телефон', with: @email
    fill_in 'Пароль', with: @password

    WAIT.until { has_button?('Войти') }
    click_button "Войти"
  end

  def logged_in?
    WAIT.until { has_xpath?("//span[text()='#{@email}']") }
    has_xpath?("//span[text()='#{@email}']")
  end
end

 