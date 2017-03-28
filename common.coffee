###
  工具类
###
_path = require 'path'
_crypto = require 'crypto'
_events = require 'events'
_moment = require 'moment'
_ = require 'lodash'
_fs = require 'fs-extra'

_util = require 'util'
_pageEvent = new _events.EventEmitter()

#触发事件
exports.trigger = (name, arg...)-> _pageEvent.emit(name, arg)

#监听事件
exports.addListener = (event, listener)-> _pageEvent.addListener event, listener

exports.removeListener = (event, listener)-> _pageEvent.removeListener event, listener

#获取一个正确的路径，允许相对或者绝对路径
exports.storagePath = (key)->
  relativePath = _path.join _config.storage.base, _config.storage[key]
  _path.join __dirname, _path.relative(__dirname, relativePath)


exports.log = (log, type)->
  return if not ENVISDEV
  console.log log

#获取程序的主目录
exports.rootPath = _path.dirname(require.main.filename)

exports.md5 = (text)->
  md5 = _crypto.createHash('md5')
  md5.update(text)
  md5.digest('hex')

#移除扩展名
exports.removeExt = (filename)-> filename.replace /\.\w+/, ''

#过滤掉着头尾的空格
exports.trim = (text)->
  text = text.replace(/^\s*(.+?)\s*$/, "$1") unless text
  text


exports.formatString = (text, args...)->
  return text if not text
  #如果第一个参数是数组，则直接使用这个数组
  args = args[0] if args.length is 1 and args[0] instanceof Array
  text.replace /\{(\d+)\}/g, (m, i) -> args[i]


#清除对象中的undefined
exports.cleanUndefined = (hash)->
  (delete hash[key] if value is undefined) for key, value of hash
  hash

#移掉html中的标签
exports.html2text = (html)->
  return html if not html
  html.replace(/<br\s?\/?>/ig, '\n')
    .replace(/&nbsp;/ig, ' ')
    .replace(/<\/?[^>]*>/g, '')
    .replace(/[ | ]* /g, ' ')
    .replace(RegExp(' ', 'gi'), '')
#    .replace(/ [\s| | ]* /g,' ')

#枚举
exports.enumerate =
  projectFlag:
    wiki: 1
    service: 2
    normal: 0

#安全转换JSON
exports.parseJSON = (text)->
  return {} if not text or typeof(text) isnt 'string'
  JSON.parse text


exports.getDayStart = (date)->
  date = new Date() if !date
  new Date(date.toJSON().split('T')[0]+' 00:00:00')


exports.writeFile = (name, file)->
  time = _moment(file.time_end + 1);
  path = _config.file.path
  path_time = _path.join(time.year().toString(), (time.month()+1).toString(), time.date().toString(), time.hour().toString())
  path = path.replace(':time', path_time)
  path = path.replace(':name', name)

  result = JSON.parse "[#{file.toString()}]"

  _fs.outputFile path, JSON.stringify(result), ()->
    setTimeout(()->
      _request.get "#{_config.wpm.url}?page=#{encodeURI(name)}&time=#{time.valueOf()}"
    ,10000)




exports.writePlayerFile = (file)->
  time = _moment(file.time_end + 1);
  path = _config.file.player_path
  path_time = _path.join(time.year().toString(), (time.month()+1).toString(), time.date().toString(), time.hour().toString())
  path = path.replace(':time', path_time)

  result = JSON.parse "#{JSON.stringify(file)}"

  _fs.outputFile path, JSON.stringify(result), ()->

exports.getSplitTime = (timeStart, timeEnd, timeType)-> 
  timeArr = []
  type = 
    minute: 60 * 1000
    hour: 60 * 60 * 1000
    day: 24 * 60 * 60 * 1000
  content = Math.round((timeEnd - timeStart)/type[timeType])
  for i in [0...content]
    moment = _moment(timeEnd).subtract(content - i, timeType)
    timeArr.push
      timeStart: moment.startOf(timeType).valueOf()
      timeEnd: moment.endOf(timeType).valueOf()
      timeStep: type[timeType]
      timeType: timeType
  timeArr

  # 获取客户端IP
exports.getClientIp = (req)-> 
  # req.headers['x-forwarded-for'] ||
  # req.connection.remoteAddress ||
  # req.socket.remoteAddress ||
  # req.connection.socket.remoteAddress

  forwardedIpsStr = req.headers['X-Forwarded-For']

  ipAddress = forwardedIpsStr.split(',')[0] if forwardedIpsStr
    
  ipAddress = req.connection.remoteAddress if !ipAddress

  ipAddress = if /((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))/.test ipAddress then RegExp.$1 else '127.0.0.1'

