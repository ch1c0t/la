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
        p json
        collocation, offset = json.values_at 'collocation', 'offset'

        if collocation
          query = 'SELECT rowid,* FROM sentences WHERE sentence MATCH ? LIMIT ? OFFSET ?'
          quoted_collocation = '"' + collocation + '"'
          limit = 8
          offset = offset || 0

          DB[query, quoted_collocation, limit, offset].to_a
            .map.with_index(offset) do |h, i|
              sentence = h[:sentence].sub(collocation) { "<mark>#{collocation}</mark>" }
              "<b>#{i}</b></br>#{sentence}"
            end
        else
          []
        end
      end
    end
  end
end
