$ = require 'jquery'
io = require 'socket.io-client'
App = require './appMobile'
Bg = require '../assets/mobile-index-bg.png'
class Mobile
  socket: null

  constructor: () ->
    @socket = io.connect('/mobile')
    @socket.on 'device:paired', @alertConnection
    $('#startApp').click (evt)=>
      evt.preventDefault()
      if $('#startApp').attr('success') == 'true'
        @socket.emit 'start:app'
        @app = new App {
          width: window.innerWidth
          height: window.innerHeight
          transparent: true
        }, @socket
        $('body').css('margin', '0')
      else $('.box').css('display', 'none')
      $('body').css('overflow', 'scroll')
      $('.lightbox').css('display', 'none')
    if $('input[name=code]').val() != ''
      @tryConn()
    $('form').submit (evt)=>
      evt.preventDefault()
      @tryConn()
  tryConn:()=>
    code = $('input[name=code]').val()
    @socket.emit 'try:connection', code
    
  alertConnection:(success)=>
    if success
      $('#msg').html('¡Te has conectado con éxito!')
      $('#startApp').html('Comenzar').attr('success', 'true')
    else
      $('#msg').html('No se ha encontrado el codigo.')
      $('#startApp').html('Regresar').attr('success', 'false')
    $('.box').css('display', 'block')
    $('.lightbox').css('display', 'block')
    document.body.scrollTop = 0
    document.documentElement.scrollTop = 0
    $('body').css('overflow', 'hidden')
module.exports = Mobile
