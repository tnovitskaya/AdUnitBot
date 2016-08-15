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

  def initialize(email, password)
    @email = email
    @password = password
  end

  def login
    visit "http://target.my.com/"
    sleep(5)
    auth_button = find(:xpath, "//span[text()='Войти']")
    auth_button.click

    fill_in 'Email или телефон', with: @email
    fill_in 'Пароль', with: @password
    click_button "Войти"

    raise "Invalid login or password" unless logged_in?
  end

  def choose_platform(platform_id)
    find(:xpath, "//a[contains(@href, '#{platform_id}')]").click
  end

  def verifies_platform?(platform_id)
    login
    choose_platform(platform_id)
    find(:xpath, "//a[contains(@href, '#{platform_id}/edit')]")
  end

  private

  def logged_in?
    sleep(5)
    has_link? "Создать площадку"
  end
end
