zmq = require "zmq"
child = require "child_process"

exports.createEngine = =>
  child.spawn("julia", ["backend.jl"])
  sock = zmq.socket "req"
  sock.connect "tcp://127.0.0.1:2000"
  sock.on "message", (msg) =>
    engine.text msg.toString() 
    next()

  engine = require('sense-engine')()

  engine.complete = (substr, cb) => 
    cb([substr])

  engine.interrupt = =>
     console.log("Interrupt received")

  engine.execute = (code, next) =>
    engine.code(code, 'text/julia')
    sock.send(code)

  engine.chunk = (code, cb) =>
    cb(code.split('\n'))

  engine.ready()
  return engine





