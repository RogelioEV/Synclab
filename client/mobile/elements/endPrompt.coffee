$ = require 'jquery'
gsap = require 'gsap'
class StageEnd

  constructor: (app) ->
    @app = app
    @btn = '<div class="startBtn text-center"> Continuar </div>'
    @lbx = '<div class ="lightbox"> </div>'
    $('body').append(@btn)
    $('body').append(@lbx)
    @btn = $('.startBtn')
    @lbx = $('.lightbox')
    @lbx.css('display', 'inline-block')
    @btn.css('font-size', '3em')
    @lbx.css('opacity', '0')
    @btn.css('opacity', '0')
    @btn.click(@continuar)
    @app.socket.on 'ocultar:continuar', @hide
    @app.socket.on 'mostrar:continuar', @show
    @app.socket.on 'terminar:tutorial', =>
      @app.isTutorial = false
      @hide()
  hide:=>
    @lbx.css('display', 'none')
    @btn.css('display', 'none')
    gsap.TweenMax.to @btn, 0.5, {opacity:0}
    gsap.TweenMax.to @lbx, 0.5, {opacity:0}
  show:=>
    @lbx.css('display', 'inline-block')
    @btn.css('display', 'inline-block')
    gsap.TweenMax.to @btn, 0.5, {opacity:1}
    gsap.TweenMax.to @lbx, 0.5, {opacity:.6}
  continuar:=>
    if @app.isTutorial
      @app.socket.emit 'continuar:tutorial'
      return null
    @hide()
    @app.socket.emit 'iniciar:stage'
module.exports = StageEnd