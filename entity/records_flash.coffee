#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:flash基础数据


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsFlash extends _BaseEntity
    constructor: ()->
      super require('../schema/records_flash').schema

module.exports = new RecordsFlash