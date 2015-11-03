

_express = require 'express.io'
_http = require 'http'
_app = _express()
_cpus = require('os').cpus()
_cluster = require 'cluster'
# _redisStore = new require('connect-redis')(_express)
# _app.http().io()

_config = require './config'



port = 9801

if _cluster.isMaster
  _cpus.forEach(()->
    _cluster.fork()
  )
  _cluster.on('exit', (worker, code, signal)->
    console.log('worker ' + worker.process.pid + ' died')
  )
  _cluster.on('listening', (worker, address)->
    console.log("A worker with #"+worker.id+" is now connected to " +
      address.address +
    ":" + address.port)
  )
else
  _app.configure(()->
    _app.use(_express.methodOverride())
    _app.use(_express.bodyParser())
    _app.use(_express.cookieParser())
    _app.set 'port', process.env.PORT || port
  )

  require('./initialize')(_app)

  _app.listen _app.get 'port'
  console.log "Port: #{_app.get 'port'}, Now: #{new Date()}"

