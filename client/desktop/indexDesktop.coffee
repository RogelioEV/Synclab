$ = require 'jquery'
io = require 'socket.io-client'
App = require './appDesktop'
bg = require '../assets/desktop-index-bg.png'
syncLogo = require '../assets/synclab.png'
class Desktop
  socket: null

  constructor: () ->
    console.log 'new desktop client'
    @socket = io('/desktop')
    @startApp()
    @socket.on 'start:app', @startApp
    @socket.on 'device:paired', (code)=>
      console.log "Conected with mobile, code: #{code}"
      $('#msg').html('Los dispositivos se han conectado satisfactoriamente.')
      $('.box').css('display', 'block')
      $('.lightbox').css('display', 'block')
  startApp:=>
    console.log 'Pixi Launch'
    @app = new App({
      width: window.innerWidth
      height: window.innerHeight
      transparent: true
    }, @socket)
    $('body').css('margin', '0')
    $('.box').css('display', 'none')
    # $('body').css('overflow', 'scroll')
    $('.lightbox').css('display',)
module.exports = Desktop
