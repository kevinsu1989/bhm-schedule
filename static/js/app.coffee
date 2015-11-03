#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:
'use strict'

define [
  'ng'
  'v/ui-router'
  './services'
  './filters'
  './directives'
  './controllers'
], (_ng) ->
  _ng.module 'app', [
    'app.filters'
    'app.directives'
    'app.controllers'
    'ui.router'
  ]