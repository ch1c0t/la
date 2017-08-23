html = require 'html-webpack-plugin'

load_css =
  test: /\.css$/
  use: [
    'style-loader'
    'css-loader'
  ]

load_sass =
  test: /\.sass$/
  use: [
    'style-loader'
    'css-loader'
    'sass-loader'
  ]

load_coffee =
  test: /\.coffee$/
  use: 'coffee-loader'

module.exports =
  entry: './src/main.coffee'
  output:
    path: "#{__dirname}/dist"
    filename: 'main.js'
  module:
    rules: [
      load_css
      load_sass
      load_coffee
    ]
  plugins: [
    new html
      title: "La"
      hash: on
  ]
