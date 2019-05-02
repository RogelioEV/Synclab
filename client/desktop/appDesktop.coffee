#Dependencies
$               = require 'jquery'
PIXI            = require 'pixi.js'
WebFont         = require 'webfontloader'
Stopwatch       = require 'statman-stopwatch' 
#Game Objects 
Matraz          = require './elements/Matraz'
Pedido          = require './elements/Pedido'
StageEnd        = require './elements/StageEnd'
Barra           = require './elements/Barra'
Recipie         = require './elements/Recipie'
Tutorial        = require './elements/tutorial'
#MatrazAssets 
MatrazJson      = require '../assets/mtzjson.json'
MatrazImg       = require '../assets/mtz.png'
MatrazLiquid    = require '../assets/mtzliquid.png'
#Ui Assets  
BgImg           = require '../assets/desktop-app-bg.png'
StageEndImg     = require '../assets/EndPrompt.png'
BarImg          = require '../assets/Bar.png'
PedidoImg       = require '../assets/Pedido.png'
RecipieImg      = require '../assets/Recipie.png'
TitleImg        = require '../assets/Title.png'
GasolinaImg     = require '../assets/Gasolina.png'
AlkaseltzerImg  = require '../assets/Alkaseltzer.png'
JabonImg        = require '../assets/Jabon.png'
InsecticidaImg  = require '../assets/Insecticida.png'
BarraImg        = require '../assets/BarradeProgreso.png'  
PerfumeImg      = require '../assets/Perfume.png'

class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]
  pedidos:[]
  recetas: []
  completos:0
  stageComplete: false
  constructor: (config, socket) ->
    super(config)
    @socket = socket
    @stopwatch = new Stopwatch()
    WebFont.load {
      custom: {
        families: ['Gotham Rounded']
        urls:['https://cdn.jsdelivr.net/npm/gotham-fonts@1.0.3/css/gotham-rounded.css']
      }
    }
    PIXI.loader
      .add([
        BgImg
        MatrazImg
        MatrazLiquid
        StageEndImg
        BarImg
        PedidoImg
        RecipieImg
        TitleImg
        GasolinaImg
        AlkaseltzerImg
        InsecticidaImg
        JabonImg
        BarraImg
        PerfumeImg
      ])
      .load(@buildApp)
  buildApp:=>
    $('body').css('background-image', "url(#{BgImg})")
    $('body').css('overflow', 'hidden')
    $('body').html @view
    $("<div class='desktop-game-title text-center'> <h3> Pedidos </h3></div>").appendTo('body')
    @matraz = new Matraz(@, MatrazImg, MatrazLiquid)
    @barra = new Barra(@, BarraImg, BarImg)
    @StageEnd = new StageEnd(@, {tiempo:10, pedidos:20}, StageEndImg)
    for i in [0..3]
      @recetas.push new Recipie(i, @, RecipieImg)      
    @buildSocketComs()
    @animate()
    
  buildSocketComs:=>
    @socket.on 'verter:sustancia', (sustancia)=>
      @pedidos[0].checkSubstance(sustancia)
    @socket.on 'reiniciar:mezcla', =>
      @matraz.restart()
      @barra.restart()
    @socket.on 'iniciar:tutorial', =>
      @recipieTutorial()
    @socket.on 'iniciar:stage', =>
      @newStage()
  nuevoPedido:(type)=>
    pedido = new Pedido(@, type, [PerfumeImg, AlkaseltzerImg, JabonImg, InsecticidaImg, PedidoImg])
    @pedidos.push pedido
  recipieTutorial:()=>
    @tutorial = new Tutorial @
    for i in [0..3] by 1
      @nuevoPedido(i)
    @stopwatch.start()
  newStage:()=>
    if @StageEnd.up
      @StageEnd.moveDown()
    for i in [1..12]
      @nuevoPedido(Math.floor(Math.random()*4))
    @stopwatch.start()
  completarPedido:=>
    if @pedidos[0].complete()
      for pedido in @pedidos
        if pedido.position > 0 
          pedido.position--
          pedido.moveUp()
      @pedidos.splice 0, 1
  addAnimationNodes:(child)=>
    @animationNodes.push child
    null
  removeAnimationNodes:(child)=>
    @animationNodes.splice @animationNodes.indexOf(child), 1
  animate:=>
    @ticker.add ()=>
      if @pedidos.length <= 0 && !@StageEnd.up && @stageComplete
        @time = @stopwatch.stop()
        @stopwatch.reset()
        @StageEnd.moveUp()
        @StageEnd.up = true
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
