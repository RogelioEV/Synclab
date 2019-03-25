$ = require 'jquery'
io = require 'socket.io-client'
App = require './appMobile'
class Mobile
  socket: null

  constructor: () ->
    console.log 'new mobile client'
    @socket = io.connect('/mobile')
    @socket.on 'device:paired', @alertConnection
    $('#startApp').click (evt)=>
      evt.preventDefault()
      if $('#startApp').attr('success') == 'true'
        @socket.emit 'start:app'
        @app = new App {
          width: window.innerWidth
          height: window.innerHeight
          backgroundColor: '0xCCCCCC'
        }, @socket
        $('body').css('margin', '0')
      else $('.box').css('display', 'none')
      $('body').css('overflow', 'scroll')
      $('.lightbox').css('display', 'none')
    $('form').submit (evt)=>
      evt.preventDefault()
      code = $('input[name=code]').val()
      @socket.emit 'try:connection', code
      console.log 'trying to connetct with code', code

  alertConnection:(success)=>
    if success
      console.log 'The device has connected succesfully'
      $('#msg').html('Los dispositivos se han conectado satisfactoriamente.')
      $('#startApp').html('Comenzar').attr('success', 'true')
    else
      $('#msg').html('No se ha encontrado el codigo.')
      $('#startApp').html('Regresar').attr('success', 'false')
      console.log 'Unable to find code'
    $('.box').css('display', 'block')
    $('.lightbox').css('display', 'block')
    document.body.scrollTop = 0
    document.documentElement.scrollTop = 0
    $('body').css('overflow', 'hidden')
module.exports = Mobile
