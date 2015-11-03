#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:

_fs = require 'fs'
_common = require '../common'
_path = require 'path'

(->
  _fs.readdirSync(__dirname).forEach (filename)->
    return if not /coffee$/.test filename or /^index\./.test filename
    key = _common.removeExt(filename)
    module.exports[key] = require _path.join(__dirname, filename)
)()
