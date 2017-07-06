require 'hobby'

require 'sequel'

module La
  DB = Sequel.sqlite "#{ENV['HOME']}/.la/db.sqlite"
end

module La
  module Web
    class Sentences
      include Hobby

      post do
        json = ::JSON.parse request.body.read
        collocation, offset = json.values_at 'collocation', 'offset'

        if collocation
          query = 'SELECT rowid,* FROM sentences WHERE sentence MATCH ? LIMIT ? OFFSET ?'
          quoted_collocation = '"' + collocation + '"'
          limit = 8
          offset = offset || 0

          DB[query, quoted_collocation, limit, offset].to_a
            .map.with_index(offset) do |h, i|
              sentence = h[:sentence].sub(collocation) { "<mark>#{collocation}</mark>" }
              sentence_with_index = "<b>#{i}</b></br>#{sentence}"
              "<div class='item'>#{sentence_with_index}</div>"
            end.join
        else
          response.status = 422
          "The required field 'collocation' is missing in the JSON body."
        end
      end
    end
  end
end
