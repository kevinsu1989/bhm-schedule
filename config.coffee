

module.exports =
  database:
    client: 'mysql',
    connection:
      host     : '123.59.21.19',
      user     : 'monitor',
      password : 'hunantv.com~110629962',
      database : 'monitor'

  api_runner: 'app.coffee'

  apiport:8200

  port:8100


  redis:
    server: 'localhost'
    port: 6379
    database: 0
    unique: 'bhf-c63a6d217'

  file:
    path: '/data/wpm/bhm/:time/:name'
  wpm:
    url: 'http://10.100.5.113/action/userPlayer'
