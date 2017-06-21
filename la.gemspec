Gem::Specification.new do |g|
  g.name    = 'la'
  g.files   = `git ls-files`.split($/)
  g.version = '0.0.0'
  g.summary = 'A local Tatoeba.'
  g.authors = ['Anatoly Chernow']

  g.add_dependency 'hobby-pages'
  g.add_dependency 'sqlite3'
  g.add_dependency 'sequel'
end
