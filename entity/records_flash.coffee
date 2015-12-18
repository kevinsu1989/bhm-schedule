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


  getRecords: (data, cb)->
    sql = "select (SELECT count(*) FROM records_flash where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as flash_load,
          (SELECT count(*) FROM records_flash_ad where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as ad,
          (SELECT count(*) FROM records_flash_cms where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as cms,
          (SELECT count(*) FROM records_flash_dispatch where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as dispatch,
          (SELECT count(*) FROM records_flash_play where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as play,
          (SELECT count(*) FROM records_flash_video_load where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as video_load,
          (SELECT count(*) FROM records_flash_video_load where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as video_load,
          #{data.time_end} as time_end ,#{data.time_start} as time_start, '#{data.time_type}' as time_type" 


module.exports = new RecordsFlash