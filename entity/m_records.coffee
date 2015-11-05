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
    sql = "select (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as pv,
					(SELECT count(*) FROM m_records_detail where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as detail,
					(SELECT count(*) FROM m_records_source where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as source,
					(SELECT count(*) FROM m_records_vv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as vv,
					(SELECT count(*) FROM m_records_app where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as app,
					#{data.time_end} as time_end ,#{data.time_start} as time_start, '#{data.time_type}' as time_type" 


    console.log sql


    @execute sql, cb



module.exports = new MRecordsPV