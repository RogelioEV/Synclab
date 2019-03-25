PIXI = require 'pixi.js'
$ = require 'jquery'

class MobileApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
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
