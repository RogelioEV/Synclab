$ = require 'jquery'
PIXI = require 'pixi.js'
# Matraz = require './elements/'
MatrazImg = require '../assets/MATRAZ.png'
LiquidImg = require '../assets/AZUL.png'
class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    @socket = socket
    PIXI.loader.add(MatrazImg).add(LiquidImg).load(@buildApp)
    console.log MatrazImg
  buildApp:=>
    $('body').html @view
    @matraz = new Matraz()
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
