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
    sql = "insert into records_history select 
	id,page_name,version,browser_name,browser_version,ip,resolution,district,timestamp,first_paint,dom_ready,load_time,
	first_view,flash_load,snail_name,snail_duration,flash_load_time,hash,url,server_version,flash_installed,flash_version,
	flash_js_load,ua,cli_version,flash_js_load_start,repost,refer


    from records where id > (select max(id) from records_history)"
    
    @execute sql, cb

module.exports = new RecordsHistory