zmq = require "zmq"
child = require "child_process"
shell = require "shelljs"

process.on "uncaughtException", (err) =>
  console.log err.stack.toString()

exports.createEngine = =>
  #child.spawn("julia", ["backend.jl"])
  console.log "julia #{__dirname}/backend.jl"
  shell.exec "julia #{__dirname}/backend.jl", {async: true}
  sock = zmq.socket "req"
  sock.connect "tcp://127.0.0.1:2000"
  
  engine = require('sense-engine')()

  engine.complete = (substr, cb) => 
    cb([substr])

  engine.interrupt = =>
     console.log("Interrupt received")

  engine.execute = (code, next) =>
    engine.code(code, 'julia')
    sock.send(code)
    sock.once "message", (msg) =>
      engine.text msg.toString() 
      next()

  engine.chunk = (code, cb) =>
    cb(code.split('\n'))
  
  setTimeout (=> engine.ready()), 2000 
  return engine





