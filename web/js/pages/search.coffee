window.find = (element) ->
  fetch '/api/sentences',
    method: 'post'
    headers:
      'Content-Type': 'application/json'
      'Accept': 'application/html'
    body: (JSON.stringify collocation: element.value)
    
  .then (response) -> response.text()
  .then (sentences) ->
    items = document.getElementById 'items'
    items.innerHTML = sentences
  .catch (error) ->
    console.log error



###
angular.module 'Search', ['infinite-scroll']
  .factory 'Data', [
    ->
      models:
        collocation: ""
        sentences: []
  ]

  .factory 'Ajax', [
    '$http'
    'Data'

    (http, data) ->
      find: (collocation) ->
        data.collocation = collocation

        query = collocation: collocation

        http.post('/api/sentences', query)
          .then (response) ->
            data.models.sentences = response.data

      loadMore: ->
        query =
          collocation: data.collocation
          offset: data.models.sentences.length

        http.post('/api/sentences', query)
          .then (response) ->
            data.models.sentences.push response.data...
  ]

  .controller 'QueryCtrl', [
    '$scope'
    'Ajax'

    (s, ajax) ->
      s.find = (collocation) ->
        s.scrollDisabled = yes
        ajax.find collocation
        s.scrollDisabled = no
  ]

  .controller 'ItemsCtrl', [
    '$scope'
    'Data'
    'Ajax'

    (s, data, ajax) ->
      s.models = data.models
      s.loadMore = -> ajax.loadMore()
  ]

  .filter 'html', [
    '$sce'

    (sce) -> sce.trustAsHtml
  ]
###
