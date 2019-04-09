$ = require 'jquery'
PIXI = require 'pixi.js'
Matraz = require './elements/Matraz.coffee'
MatrazJson = require '../assets/mtzjson.json'
MatrazImg = require '../assets/mtz.png'
Bg = require '../assets/desktop-app-bg.png'
MatrazLiquid = require '../assets/mtzliquid.png'
class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    @animate()
    @socket = socket
    PIXI.loader
      .add(Bg)
      .add(MatrazImg)
      .add(MatrazLiquid)
      .load(@buildApp)
  buildApp:=>
    $('body').css('background-image', "url(#{Bg})")
    $('body').css('overflow', 'hidden')
    $('body').html @view
    @matraz = new Matraz(@, MatrazImg, MatrazLiquid)
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
