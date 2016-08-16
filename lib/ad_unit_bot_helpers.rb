module AdUnitBotHelpers

  def created_new_ad_unit(block_params = {})
    title = block_params[:title]
    AdUnitBot::WAIT.until { has_link?(AdUnitBot::CREATE_BLOCK_BTN_TEXT) }
    pagination do
      return if first(:xpath, "//table/tbody/tr/td/div/a[text()='#{title}']")
    end

    raise 'New ad unit not found'
  end

  def pagination(&block)
    loop do
      yield
      break if next_page_link[:class].include?("_disabled")

      next_page_link.click
    end
  end

  def next_page_link
    find(:xpath, "//div[contains(@class, 
           'paginator__button paginator__button_right js-control-inc')]")
  end
end
