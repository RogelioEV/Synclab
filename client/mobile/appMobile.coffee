PIXI = require 'pixi.js'
$ = require 'jquery'
Bg = require '../assets/mobile-app-bg.png'
class MobileApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    $('body').css('background-image', "url(#{Bg})")
    @socket = socket
    $('body').html @view
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()
module.exports = MobileApp
