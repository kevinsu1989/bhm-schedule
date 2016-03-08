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
    sql = "SELECT (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/play%') as pv,
          (SELECT count(*) FROM (SELECT distinct(cookie) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/play%') m) as uv,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as pv_all,
          (SELECT count(*) FROM (SELECT distinct(cookie) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) m) as uv_all,
					(SELECT count(*) FROM m_records_detail where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as detail,
					(SELECT count(*) FROM m_records_source where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as source,
					(SELECT count(*) FROM m_records_vv where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as vv,
					(SELECT count(*) FROM m_records_app where timestamp>#{data.time_start} and timestamp<#{data.time_end}) as app,
					#{data.time_end} as time_end ,#{data.time_start} as time_start, '#{data.time_type}' as time_type" 

    if data.time_type is 'day'
      sql += ",(SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/channel/1001%') as pv_c_1,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/channel/1003%') as pv_c_3,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/channel/1004%') as pv_c_4,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/channel/1005%') as pv_c_5,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/channel/1006%') as pv_c_6,
          (SELECT count(*) FROM m_records_pv where timestamp>#{data.time_start} and timestamp<#{data.time_end} and url like '%.com/#/search%') as pv_s"


    console.log sql


    @execute sql, cb



module.exports = new MRecordsPV