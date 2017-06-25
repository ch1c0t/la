#=require angular

angular.module 'Search', []
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
          offset: (data.models.sentences.length+1)

        http.post('/api/sentences', query)
          .then (response) ->
            data.models.sentences.push response.data...
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
    'Ajax'

    (s, data, ajax) ->
      s.models = data.models
      s.loadMore = -> ajax.loadMore()
  ]

  .filter 'html', [
    '$sce'

    (sce) -> sce.trustAsHtml
  ]

  .directive 'whenScrolled', ->
    (scope, element, attribute) ->
      raw = element[0]

      element.bind 'scroll', ->
        if (raw.scrollTop + raw.offsetHeigth) >= raw.scrollHeigth
          scope.$apply attribute.whenScrolled
