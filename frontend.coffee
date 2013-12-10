zmq = require "zmq"

sock = zmq.socket "req"
sock.connect "tcp://127.0.0.1:2000"
sock.on "message", (msg) => console.log msg.toString()

sock.send "1 + 3"


