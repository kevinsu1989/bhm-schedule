#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description: 页面配置

_BaseEntity = require('bijou').BaseEntity
_async = require 'async'


class Page extends _BaseEntity
  constructor: ()->
    super require('../schema/page').schema


  findPages: (cb)->
    sql = "select * from page"

    @execute sql, cb



module.exports = new Page