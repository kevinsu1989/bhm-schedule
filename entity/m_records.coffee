_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class MRecordsPV extends _BaseEntity
  constructor: ()->
    super require('../schema/m_records_pv').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

  getRecords: (data, cb)->
    sql = "SELECT (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like 'http://m.hunantv.com/#/play%') as pv,
          (SELECT count(*) FROM (SELECT distinct(cookie) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like 'http://m.hunantv.com/#/play%') m) as uv,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as pv_all,
          (SELECT count(*) FROM (SELECT distinct(cookie) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) m) as uv_all,
					(SELECT count(*) FROM m_records_detail where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as detail,
					(SELECT count(*) FROM m_records_source where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as source,
					(SELECT count(*) FROM m_records_vv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as vv,
					(SELECT count(*) FROM m_records_app where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as app,
					#{data.time_end} as time_end ,#{data.time_start} as time_start, '#{data.time_type}' as time_type" 


    console.log sql


    @execute sql, cb



module.exports = new MRecordsPV