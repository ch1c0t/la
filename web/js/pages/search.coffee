#=require angular

angular.module 'Search', []
  .factory 'Data', [
    ->
      models:
        sentences: []
  ]

  .factory 'Ajax', [
    '$http'
    'Data'

    (http, data) ->
      find: (collocation) ->
        query = collocation: collocation
        http.post('/api/sentences', query)
          .then (response) ->
            data.models.sentences = response.data
  ]

  .controller 'QueryCtrl', [
    '$scope'
    'Ajax'

    (s, ajax) ->
      s.find = (collocation) ->
        ajax.find collocation
  ]

  .controller 'ItemsCtrl', [
    '$scope'
    'Data'

    (s, data) ->
      s.models = data.models
  ]

  .filter 'html', [
    '$sce'

    (sce) -> sce.trustAsHtml
  ]
