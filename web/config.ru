require 'hobby/pages'
require 'foundation/scss/in/sass_path'
require 'rails-assets-angular'

require_relative 'api/sentences'

map('/api/sentences') { run La::Web::Sentences.new }

run Hobby::Pages.new '.'
