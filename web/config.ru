require 'fileutils'

require 'sequel'
require 'hobby/pages'

class Upload
  include Hobby

  post do
    FileUtils.mkdir_p '~/.la'
    db = Sequel.sqlite '~/.la/db.sqlite'
    db.run "CREATE VIRTUAL TABLE sentences USING fts5(string);"

    file = request.params['dump'][:tempfile]
    file.each_line.lazy.each_slice(10000) do |chunk|
      sentences = []

      chunk.each do |line|
        #tatoeba_id, language, sentence = CSV.parse(line, col_sep: "\t", quote_char: "\x00").first
        tatoeba_id, language, sentence = line.split "\t"
        sentences << sentence if language == 'eng'
      end

      db.transaction do
        sentences.each_with_index do |sentence, index|
          db[:sentences] << { rowid: index, string: sentence }
        end
      end
      puts 'thousand'
    end

    puts 'the end'
    response.redirect '/import'
  end
end

map('/upload') { run Upload.new }
run Hobby::Pages.new '.'
