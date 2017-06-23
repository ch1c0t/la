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
        query = '"' + json['collocation'] + '"'
        limit = 16
        select = 'SELECT rowid,* FROM sentences WHERE sentence MATCH ? LIMIT ?'

        sentences = DB[select, query, limit].to_a.map { |h| h[:sentence] }
        p sentences
        p '========'
        sentences
      end
    end
  end
end
