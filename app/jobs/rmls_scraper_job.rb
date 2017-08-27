class RmlsScraperJob

  attr_reader :browser

  def perform
    Watir.default_timeout = 90
    @browser = Watir::Browser.new :chrome, headless: true

    browser.goto 'http://www.rmls.com/rc2/UI/search_residential.asp'
    property_type = browser.select_list id: 'PROPERTY_TYPE'
    property_type.select 'Detached Single Family'
    set_text('PRICE1', 300)
    set_text('ZIP1', 97229)
    set_text('ZIP2', 97223)
    browser.input(:class=> 'searchButton').click
    save_listings(get_listings)
    while next_page_link.exists?
      next_page()
      save_listings(get_listings)
    end
  end

  def set_text(id, value)
    field = browser.text_field id: id
    field.set value
  end

  def click_button(id)
    btn = browser.button value: 'Search'
    btn.exists?
    btn.click
  end

  def current_page
    @current_page ||= browser.span(class: 'PAGER_NONLINK').text.to_i
  end

  def next_page_link
    @next_page_link ||= begin
      if browser.link(class: 'PAGER_LINK', text: "#{current_page+1}").exists?
        browser.link(class: 'PAGER_LINK', text: "#{current_page+1}")
      else
        browser.link(class: 'PAGER_LINK', text: ">>")
      end
    end
  end

  def next_page
    if next_page_link.exists?
      puts "Navigating to page #{current_page+1} of results"
      next_page_link.click
      @current_page = nil
      @next_page_link = nil
    else
      puts "End of results"
    end
  end

  def get_listings
    puts "extracting listings"
    result = []
    report_table = browser.table(class: 'REPORT_TABLE')
    report_table.rows.take(5).each do |row|
      listing = {}
      result_table = row.tables[1]
      puts "extracting rmls_number"
      listing['rmls_number'] = result_table.link(class: 'LINK_MLN').title.match(/\d+/)[0]
      result_table.rows.each do |r|
        r.tables[1].rows.each do |detail_rows|
          detail_rows.cells.each do |cell|
            listing[:tuples] ||= []
            listing[:tuples].push(cell.text)
          end
        end
      end
      hash = tuples_to_h(listing.delete(:tuples))
      result.push(listing.merge(hash))
    end
    puts "finished extracting listings"
    puts result
    result
  end

  def save_listings(listings)
    listings.each do |listing|
      l = Listing.where(rmls_number: listing['rmls_number']).first_or_initialize
      if !l.new_record? && l.price != listing['price'].to_i
        PriceHistory.create(rmls_number: listing['rmls_number'], old_price: l.price, new_price: listing['price'])
      end
      l.assign_attributes(listing.slice('nhoodbldg', 'taxyr', 'yrbuilt', 'elem', 'baths', 'beds', 'sqft', 'price', 'status', 'county', 'address'))
      l.save
    end
  end

  def tuples_to_h(tuple_array)
    puts "converting tuples to hash"
    puts "tuples has an odd number of elements" if tuple_array.length%2 > 0
    h = {}
    until tuple_array.length == 0
      tuple = tuple_array.pop 2
      h[sanitize(tuple[0])] = sanitize_num(tuple[1])
    end
    h
  end

  def sanitize(label)
    label.gsub(/[\/:]/, '').downcase
  end

  def sanitize_num(num_str)
    num_str.gsub(/[$,]/, '')
  end
end
