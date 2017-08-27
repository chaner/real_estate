namespace :jobs do
  desc 'scrape it!'
  task :scrape => :environment do
    puts "starting"
    RmlsScraperJob.new.perform
    puts "ending"
  end
end
