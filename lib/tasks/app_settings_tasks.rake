namespace :app_settings do
  task :migrate => :environment do
    Rails.migrate("app_settings")
  end
end
namespace :db do
  task :migrate => 'app_settings:migrate'
end