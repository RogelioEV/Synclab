PIXI = require 'pixi.js'
$ = require 'jquery'
Bg = require '../assets/mobile-app-bg.png'
Tubo = require './elements/tubo.coffee'
TuboImg = require '../assets/tubo.png'
LiquidImg = require '../assets/liquid.png'
Substances = require './data/substances.JSON'
Hammer = require 'hammerjs'
class MobileApp extends PIXI.Application
  animation:true
  animationNodes:[]
  tubos:{}
  constructor: (config, socket) ->
    super(config)
    @socket = socket
    PIXI.loader
      .add(TuboImg)
      .add(LiquidImg)
      .add(Bg)
      .load @buildApp
  buildApp:=>
    $('body').css('background-image', "url(#{Bg})")
    $('body').html @view
    imgs = [TuboImg, LiquidImg]
    i=0
    for substance, model of Substances
      model.scale = i%2 * 0.1 + 0.3
      @tubos[substance] = new Tubo(imgs, model, @)
      @tubos[substance].position = i 
      console.log @tubos[substance].position
      @tubos[substance].x = window.innerWidth/2 * i++
      @tubos[substance].y = window.innerHeight/2
    @manager = new Hammer @view
    @manager.on 'swipe', (evt)=>
      switch evt.direction
        when 2
          console.log 'swipe left'
        when 4
          console.log 'swipe right'
    window.addEventListener 'deviceorientation', @orientationEvt
    @animate()
  orientationEvt:(evt)=>
    alpha = Math.round evt.alpha
    beta = Math.round evt.beta
    gamma = Math.round evt.gamma

    console.log alpha, beta, gamma
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()
module.exports = MobileApp
