$ = require 'jquery'
PIXI = require 'pixi.js'
Matraz = require './elements/Matraz.coffee'
MatrazImg = require '../assets/MATRAZ.png'
LiquidImg = require '../assets/AZUL.png'
Bg = require '../assets/desktoop-app-bg.png'
class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    $('body').css('background-image', "url(#{Bg})")
    @socket = socket
    PIXI.loader.add(MatrazImg).add(LiquidImg).load(@buildApp)
    console.log MatrazImg
  buildApp:=>
    $('body').html @view
    @matraz = new Matraz([MatrazImg, LiquidImg], @)
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
