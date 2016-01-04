_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class FlashRecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/flash_calculated').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

  getRecordsForDay: (data, cb)->
    sql = "select sum(ad) as ad ,sum(ad_end) as ad_end, sum(dispatch) as dispatch, sum(video_load) as video_load, 
        sum(cms) as cms, sum(play) as play, sum(vv) as vv, sum(flash_load) as flash_load, sum(pv) as pv,sum(buffer_full) as buffer_full,
        #{data.time_start} as time_start, #{data.time_end} as time_end, '#{data.time_type}' as time_type
        FROM flash_calculated where time_start>#{data.time_start} and time_start<#{data.time_end}) and time_type='hour'" 
    @execute sql, cb

    

  findRecords: (data, cb)->
    sql="select * from flash_calculated where time_start >= #{data.time_start} and time_start < #{data.time_end}"
    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    console.log sql
    @execute sql, cb

module.exports = new FlashRecordsCalculated