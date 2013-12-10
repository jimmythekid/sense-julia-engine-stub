using ZMQ
using JSON

const ctx = Context()
const io = Socket(ctx, REP)
ZMQ.bind(io, "tcp://127.0.0.1:2000")

while true
   print("Waiting for input")
   msg = ZMQ.recv(io)
   ZMQ.send(io, msg)
end
