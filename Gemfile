source "https://#{ENV['FURY_AUTH']}@gem.fury.io/g5dev/"
source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.2.0'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 5.0'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'uglifier', '>= 1.3.0'
end

gem 'bootstrap-sass', '~> 3.3.5'
gem 'jquery-rails'
gem 'turbolinks'
gem 'twilio-ruby'
gem 'global_phone'
#gem 'g5_updatable', '~> 0.10.3'
gem 'g5_updatable', :git => 'https://github.com/g5search/g5_updatable.git', :branch => 'bump_foundation'
# gem 'g5_authenticatable'
gem "smart_listing" # https://github.com/Sology/smart_listing MIT
gem 'puma' # https://github.com/puma/puma BSD 3-Clause license
gem 'g5_heroku_app_name_formatter'

group :test do
  gem 'byebug'
  gem 'factory_girl_rails', "~> 4.0"
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end

gem 'dotenv-rails', :groups => [:development, :test]
gem 'pry', :groups => [:development, :test]

group :production do
  # Enables things like reasonably speedy logging and asset serving in Rails4
  # on Heroku.  Source: https://devcenter.heroku.com/articles/rails4
  gem 'rails_12factor'
end

