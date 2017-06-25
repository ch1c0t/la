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
        collocation, offset = json.values_at 'collocation', 'offset'

        query = 'SELECT rowid,* FROM sentences WHERE sentence MATCH ? LIMIT ? OFFSET ?'
        quoted_collocation = '"' + collocation + '"'
        limit = 8
        offset = offset || 0

        DB[query, quoted_collocation, limit, offset].to_a
          .map do |h|
            h[:sentence].sub(collocation) { "<mark>#{collocation}</mark>" }
          end
      end
    end
  end
end
