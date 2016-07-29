#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 07/28/16 11:01 AM
#    Description:基础数据处理


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class Records extends _BaseEntity
  constructor: ()->
    super require('../schema/records_mobile_basic_calculated').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


module.exports = new Records