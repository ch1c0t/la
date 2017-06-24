require 'hobby'
require 'hobby/json'

require 'sequel'

module La
  DB = Sequel.sqlite "#{ENV['HOME']}/.la/db.sqlite"
end

module La
  module Web
    class Sentences
      include Hobby
      include JSON

      post do
        collocation = json['collocation']

        query = 'SELECT rowid,* FROM sentences WHERE sentence MATCH ? LIMIT ?'
        quoted_collocation = '"' + collocation + '"'
        limit = 16

        DB[query, quoted_collocation, limit].to_a
          .map do |h|
            h[:sentence].sub(collocation) { "<mark>#{collocation}</mark>" }
          end
      end
    end
  end
end
