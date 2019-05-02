#Dependencies
PIXI            = require 'pixi.js'
$               = require 'jquery'
Hammer          = require 'hammerjs'
WebFont         = require 'webfontloader'
#GameObjects
Tubo            = require './elements/tubo.coffee'
Ui              = require './elements/Ui'
EndPrompt       = require './elements/endPrompt'
#DataAssets
Substances      = require './data/substancesuwu.JSON'
#ImgAssets
Bg              = require '../assets/mobile-app-bg.png'
TuboImg         = require '../assets/tubo.png'
LiquidImg       = require '../assets/tuboLiquid.png'
ArrowImg        = require '../assets/backArrow.png'
TrashCanImg     = require '../assets/trashCan.png'
DataboxImg      = require '../assets/DataBox.png'
StartButtonImg  = require '../assets/StartButton.png'
Btn1            = require '../assets/Btn1.png'
Btn2            = require '../assets/Btn2.png'
class MobileApp extends PIXI.Application
  animation:true
  animationNodes:[]
  tubos:{}
  tubosLength:0
  selected: false
  vertiendo: false
  isTutorial: false
  constructor: (config, socket) ->
    super(config)
    @socket = socket
    WebFont.load {
      custom: {
        families: ['Gotham Rounded']
        urls:['https://cdn.jsdelivr.net/npm/gotham-fonts@1.0.3/css/gotham-rounded.css']
      }
    }
    PIXI.loader
      .add([
        Bg
        TuboImg
        LiquidImg
        ArrowImg
        TrashCanImg
        DataboxImg
      ])
      .load @buildApp
  buildApp:=>
    $('body').css('background-image', "url(#{Bg})")
    @startBtn = "<div class='startBtn text-center'> Jugar </div>"
    @tutorialBtn = '<div class = "tutorialBtn text-center">Tutorial</div>'
    $('body').html(@startBtn)
    $('body').append(@tutorialBtn)
    $('.startBtn').click(=>
      @startApp()  
      @socket.emit 'iniciar:stage'
    )
    $('.tutorialBtn').click(=>
      @startApp()
      @socket.emit 'iniciar:tutorial'
      @isTutorial = true
      @endPrompt.show()
    )
    @socket.on 'terminar:stage', @endStage
  endStage:=>
    @endPrompt.show()
  startApp:=>
    $('body').html @view
    @ui = new Ui(@, [DataboxImg, ArrowImg, TrashCanImg])
    @endPrompt = new EndPrompt(@)
    imgs = [TuboImg, LiquidImg]
    i=0
    for substance, model of Substances
      model.scale = i%2 * 0.15 + 0.35
      @tubos[substance] = new Tubo(imgs, model, @)
      @tubos[substance].position = i
      @tubos[substance].formulaText.css('opacity', 0)
      @tubos[substance].formulaText.css('opacity', 1) if i == 1
      @tubos[substance].x = window.innerWidth/2 * i++
      @tubos[substance].y = window.innerHeight *.375
      @tubosLength++
    @manager = new Hammer @view
    @manager.on 'swipe', (evt)=>
      return if @selected
      switch evt.direction
        when 2 #left
          for name, tubo of @tubos
            tubo.position--
            tubo.changePosition(true)
        when 4 #right
          for name, tubo of @tubos
            tubo.position++
            tubo.changePosition(false)
    @animate()
  goBack:=>
    for name, tubo of @tubos
      if tubo.position == 1
        tubo.deselect()
        
  
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()
module.exports = MobileApp
