$ = require 'jquery'
io = require 'socket.io-client'
App = require './appDesktop'
bg = require '../assets/desktop-index-bg.png'
syncLogo = require '../assets/synclab.png'
qrcode = require 'qrcode-generator'
textBox = require '../assets/textBox.png'
class Desktop
  socket: null

  constructor: () ->
    console.log 'new desktop client'
    code = $('#code').attr('code')
    @socket = io('/desktop')
    qr = qrcode(0, 'L')
    qr.addData ("192.168.1.89:3000/mobile?code=#{code}")
    qr.make()
    tag = qr.createSvgTag()
    console.log tag.indexOf('74px')
    tag = tag.replace('74px', '150px')
    tag = tag.replace('74px', '150px')
    console.log tag
    $('.qr').html(tag)
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
