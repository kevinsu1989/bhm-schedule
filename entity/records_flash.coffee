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
    sql = "select (SELECT count(distinct(hash)) FROM records_flash where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as flash_load,
          (SELECT count(distinct(hash)) FROM records_flash_ad where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as ad,
          (SELECT count(distinct(hash)) FROM records_flash_ad_end where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as ad_end,
          (SELECT count(distinct(hash)) FROM records_flash_cms where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as cms,
          (SELECT count(distinct(hash)) FROM records_flash_dispatch where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as dispatch,
          (SELECT count(distinct(hash)) FROM records_flash_play where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as play,
          (SELECT count(*) FROM records_flash_play where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as vv,
          (SELECT count(distinct(hash)) FROM records_flash_video_load where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as video_load,
          (SELECT count(distinct(hash)) FROM records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and page_name='底层') as pv,
          #{data.time_end} as time_end ,#{data.time_start} as time_start, '#{data.time_type}' as time_type" 

    @execute sql, cb
module.exports = new RecordsFlash