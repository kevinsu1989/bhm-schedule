

_express = require 'express.io'
_http = require 'http'
_app = _express()
_cpus = require('os').cpus().length
_redisStore = new require('connect-redis')(_express)
# _app.http().io()

_config = require './config'

_app.configure(()->
  _app.use(_express.methodOverride())
  _app.use(_express.bodyParser())
  _app.use(_express.cookieParser())

  _ports = []

  _app.use(_express.session(
    secret: 'monitor.hunantv.com'
    store: new _redisStore(
      ttl: 60 * 60 * 24 * 365
      prefix: "#{_config.redis.unique}:session:"
      host: _config.redis.server
      port: _config.redis.port
    )
  ))

  _app.use(require('coffee-middleware')({
    src: __dirname + '/static'
    compress: true
  }))

  _app.use(require('less-middleware')(__dirname + '/static'))

  _app.use(_express.static(__dirname + '/static'))
  
  _app.set 'port', process.env.PORT || 8201
)

require('./initialize')(_app)

_app.listen _app.get 'port'
console.log "Port: #{_app.get 'port'}, Now: #{new Date()}"