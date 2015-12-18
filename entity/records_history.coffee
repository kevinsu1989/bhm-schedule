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


  saveHistoryRecords: (cb)->
    sql = "insert into records_history select * from records where id > (select max(id) from records_history)"
    
    @execute sql, cb

module.exports = new RecordsHistory