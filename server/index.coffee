http = require 'http'
app = require './server'
sha1 = require 'sha1'

server = http.createServer(app, '0.0.0.0')

server.listen 3000, ->
  console.log 'start server'

io = require('socket.io')(server)

mobile = io.of('/mobile')
desktop = io.of('/desktop')

desktop.on 'connection', (socket) ->
  console.log "User #{socket.id} has connected, address #{socket.handshake.address}"
  socket.on 'app:loaded', ()->
    console.log 'app loaded'
  socket.on 'disconnect', () ->
    console.log "User #{socket.id} has disconnected"
  socket.on 'liquido:completo', ()->
    mobile.to(socket.pair).emit('liquido:completo')
  socket.on 'terminar:stage', ->
    mobile.to(socket.pair).emit('terminar:stage')
  socket.on 'ocultar:continuar', ->
    mobile.to(socket.pair).emit('ocultar:continuar')
  socket.on 'mostrar:continuar', ->
    mobile.to(socket.pair).emit('mostrar:continuar')
  socket.on 'terminar:tutorial', ->
    mobile.to(socket.pair).emit('terminar:tutorial')
mobile.on 'connection', (socket) ->
  console.log "The user #{socket.id} has connetced, address: #{socket.handshake.address}"
  socket.on 'try:connection', (code) ->
    console.log "User #{socket.id} trying to connect w/code #{code}"
    connected = false
    for id, desktops of io.of('/desktop').sockets
      hash = sha1(desktops.handshake.address).substring(0, 4)
      if hash == code
        socket.pair = id
        desktops.pair = socket.id
        console.log "#{socket.id} paired with #{id}"
        connected = true
      else
        console.log 'Unable to find code'
    socket.emit 'device:paired', connected
    desktop.to(socket.pair).emit 'device:paired', code
  socket.on 'start:app', ()->
    console.log 'start app in desktop', socket.pair
    desktop.to(socket.pair).emit('start:app')
  socket.on 'iniciar:tutorial' , ->
    desktop.to(socket.pair).emit('iniciar:tutorial')
  socket.on 'iniciar:stage', ->
    desktop.to(socket.pair).emit('iniciar:stage')
  socket.on 'verter:sustancia', (sustancia)->
    desktop.to(socket.pair).emit('verter:sustancia', sustancia)
  socket.on 'reiniciar:mezcla', ()->
    desktop.to(socket.pair).emit('reiniciar:mezcla')
  socket.on 'continuar:tutorial', ->
    desktop.to(socket.pair).emit('continuar:tutorial')
  socket.on 'disconnect', () ->
    console.log "The user #{socket.id} disconnected"
