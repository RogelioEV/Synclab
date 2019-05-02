gsap = require 'gsap'
Pedidos = require '../data/pedidos.JSON'
class Pedido
  position: null
  badMix: false
  ingredientes: []
  constructor: (app, type, imgs) ->
    @app = app
    @type = type
    @position = @app.pedidos.length

    @sprite = new PIXI.Sprite.from(imgs[4])
    @scale = {}
    @scale.x = window.innerWidth/@sprite.width
    @scale.y = window.innerHeight/@sprite.height
    @sprite.scale = {x: .18 * @scale.x, y: .15 * @scale.y }
    @sprite.x = window.innerWidth * 0.03
    @sprite.y = window.innerHeight
    @typeSprite = new PIXI.Sprite.from(imgs[type])
    @typeSprite.anchor.set 0.5
    @scale.x = @sprite.width/@typeSprite.width
    @typeSprite.scale.x = @scale.x * .50
    @typeSprite.scale.y = @scale.x * .50
    @getIngredientes()
    @app.stage.addChild @sprite
    @app.stage.addChild @typeSprite
    @sprite.interactive = true
    @sprite.buttonMode = true
    @sprite.on 'click', @click
    @moveUp()
    @app.addAnimationNodes @
  click:=>
    @app.completarPedido()
  getIngredientes:()=>
    switch @type
      when 2
        data = Pedidos["jabon"]["ingredientes"]
        break
      when 3
        data = Pedidos["insecticida"]["ingredientes"]
        break
      when 1
        data = Pedidos["alkaseltzer"]["ingredientes"]
        break
      when 0
        data = Pedidos["perfume"]["ingredientes"]
    @ingredientes = data
    for ingrediente in @ingredientes
      for name, checked of ingrediente
        checked = false
  checkSubstance:(sustancia)=>
    flag = false
    for ingrediente in @ingredientes
      for name, checked of ingrediente
        if name == sustancia.nombre
          if !checked
            @ingredientes[@ingredientes.indexOf ingrediente][name] = true
            flag = true
    if !flag
      @badMix = true
    if @badMix then sustancia.color = '0x000000'
    @app.matraz.changeState(sustancia)
    @app.barra.changeState @badMix
  animate:=>
    @typeSprite.x = @sprite.x + @sprite.width * .5
    @typeSprite.y = @sprite.y + @sprite.height * .60
  moveUp:=>
    if @position == 0 
      for receta in @app.recetas
        if receta.type == @type
          receta.mostrar()
    newY = @sprite.height + 20
    newY *= @position
    newY += 140
    gsap.TweenMax.to(@sprite, 1, {y: newY})
  complete:=>
    for ingrediente in @ingredientes
      for name, checked of ingrediente
        if !checked
          @badMix = false
    if @badMix
      @badMix = false
      @getIngredientes()
      return false
    gsap.TweenMax.to(@sprite, .3, 
      {
        x: -@sprite.width, 
        onComplete:=>
          @app.completos+=1
          @sprite.destroy()
          @typeSprite.destroy()
          @app.removeAnimationNodes @
    })
    for receta in @app.recetas
      if receta.type == @type
        receta.ocultar()
    if @app.pedidos.length == 1
      @app.stageComplete = true
      @app.socket.emit 'terminar:stage'
    return true
module.exports = Pedido
  