#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 3/19/15 11:20 AM
#    Description: 处理路由以及socket
_async = require 'async'
_http = require('bijou').http

# _config = require './config'
_cluster = require 'cluster'


_api = require './biz/api'
_records = require './biz/records'
_browser = require './biz/browser'

receiveData = (req, res, next)->
  _api.receiveData req, res, (err, result)-> _http.responseJSON err, result, res

getRecordsSplit = (req, res, next)->
  _api.getRecordsSplit req, res, (err, result)-> _http.responseJSON err, result, res

getRecords = (req, res, next)->
  _api.getRecords req, res, (err, result)-> _http.responseJSON err, result, res

getPages = (req, res, next)->
  _api.getPages req, res, (err, result)-> _http.responseJSON err, result, res

##########################

calRecords = (req, res, next)->
  return if !req.query.time_start || !req.query.time_end || !req.query.type
  _records.calculateRecordsByTime req.query.time_start * 1, req.query.time_end * 1, req.query.type, (err, result)->
    _http.responseJSON err, result, res

calBrowser = (req, res, next)->
  return if !req.query.time_start || !req.query.time_end || !req.query.type
  _browser.calculateBrowserRecords req.query.time_start * 1, req.query.time_end * 1, req.query.type, (err, result)->
    _http.responseJSON err, result, res


#初始化路由
exports.init = (app)->

  app.all '*', (req, res, next)->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS")
    res.header("X-Powered-By",' 3.2.1')
    res.header("Content-Type", "application/json;charset=utf-8")
    next()
  #收集数据
  app.get '/api/receive', receiveData
  #批量分析
  app.get '/api/pages', getPages
  #批量分析
  app.get '/api/pages/:page_name', getRecordsSplit
  #定时分析
  app.get '/api/pages/:page_name/recent', getRecords

  ################################

  #计算数据
  app.get '/api/cal/records', calRecords
  #计算浏览器占比
  app.get '/api/cal/browser', calBrowser


  app.get /(\/\w+)?$/, (req, res, next)-> res.sendfile 'static/index.html'


