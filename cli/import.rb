require 'fileutils'
require 'sequel'

module La
  ROOT_DIRECTORY = "#{ENV['HOME']}/.la"

  module Import
    def self.[] origin, file
      origin = const_get origin.capitalize
      origin.import_sentences_from file
    end

    module Tatoeba
      def self.import_sentences_from file
        FileUtils.mkdir_p ROOT_DIRECTORY
        db = Sequel.sqlite "#{ROOT_DIRECTORY}/db.sqlite"
        db.run "CREATE VIRTUAL TABLE sentences USING fts5(sentence, language, tatoeba_id);"

        e = File.open(file).each_line.lazy
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

        "#{file} was imported."
      end
    end
  end
end
