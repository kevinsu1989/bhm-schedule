#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:备份数据

_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsHistory extends _BaseEntity
  constructor: ()->
    super require('../schema/records_history').schema


  saveHistoryRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

module.exports = new RecordsHistory