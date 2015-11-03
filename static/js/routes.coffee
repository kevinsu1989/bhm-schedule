#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:06 AM
#    Description: 路由

"use strict"
define [
  "ng"
  "app"
  'utils'
  't!/views.html'
], (_ng, _app, _utils, _template) ->

  _app.config(['$locationProvider', '$stateProvider', '$urlRouterProvider',
    ($locationProvider, $stateProvider) ->
      $locationProvider.html5Mode enabled: true, requireBase: false

      $stateProvider
      .state('main',
        url: '/'
        template: _utils.extractTemplate('#tmpl-main', _template)
        controller: 'mainController'
      )
      
  ])