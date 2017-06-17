require 'fileutils'

require 'sequel'
require 'hobby/pages'

class Upload
  include Hobby

  post do
    FileUtils.mkdir_p "#{ENV['HOME']}/.la"
    db = Sequel.sqlite "#{ENV['HOME']}/.la/db.sqlite"
    db.run "CREATE VIRTUAL TABLE sentences USING fts5(sentence, language, tatoeba_id);"

    e = request.params['dump'][:tempfile].each_line.lazy
    batch = e.first 100000
    sentences = []

    until batch.empty?
      batch.each do |line|
        tatoeba_id, language, sentence = line.split "\t"
        sentences << [sentence, language, tatoeba_id] if language == 'eng'
      end

      p batch.first
      db[:sentences].import [:sentence, :language, :tatoeba_id], sentences
      p batch.last

      batch = e.first 100000
      sentences.clear
    end

    "#{request.params['dump'][:filename]} was imported."
  end
end

map('/upload') { run Upload.new }
run Hobby::Pages.new '.'
