BarraData = require '../../assets/BarradeProgreso.JSON'
random = require './rndColor'
gsap = require 'gsap'
class Barra
  sprite: []
  animationSpeed: 0.1
  scale: 0.8
  delta: []
  constructor: (app, img, bgImg) ->
    @app = app
    baseTexture = PIXI.BaseTexture.from(img)
    frames = [[], [], []]
    @x = window.innerWidth * .8
    @y = window.innerHeight * .10
    a = 1
    for name, frame of BarraData.frames
      data = frame.frame
      rect = new PIXI.Rectangle(data.x, data.y, data.w, data.h)
      if a < 10
        frames[0].push new PIXI.Texture(baseTexture, rect)
      else if a < 18
        frames[1].push new PIXI.Texture(baseTexture, rect)
      else 
        frames[2].push new PIXI.Texture(baseTexture, rect)
      a++
    @bgSprite = new PIXI.Sprite.from(frames[0][0])
    @bgSprite.anchor.set(0.5, 1)
    @bgSprite.scale.x = @scale
    @bgSprite.scale.y = @scale
    @bgSprite.x = @x 
    @bgSprite.y = @y
    @bgSprite.tint = '0xFFFFFF'
    @app.stage.addChild @bgSprite
    for i in [0..2] by 1
      @sprite[i] = new PIXI.extras.AnimatedSprite frames[i]
      @sprite[i].animationSpeed = @animationSpeed
      @sprite[i].scale.x = @scale
      @sprite[i].scale.y = @scale
      @sprite[i].anchor.set(0.5, 1)
      @sprite[i].x = @x
      @sprite[i].y = @y
      @sprite[i].alpha = 0
      @sprite[i].loop = false
      @sprite[i].active = false
      @sprite[i].pos = i
      @app.stage.addChild @sprite[i]
    @sprite[0].alpha = 1
    
    @sprite[2].onComplete = @checkRecipie
    @app.addAnimationNodes @
  changeState:(incorrect)=>
    for sprite in @sprite
      if sprite.active
        target = sprite.pos
    if !incorrect then @newColor = '0xFF00AA'
    else @newColor = '0x000000'
    @oldColor = random.hexToRgb @bgSprite.tint
    @newColor = random.hexToRgb @newColor
    for i in [0..2] by 1
      @delta[i] = (@newColor[i] - @oldColor[i])/100
    if target < 2
      newTarget = target + 1
      @sprite[target].gotoAndStop(0)
      @sprite[target].alpha = 0
      @sprite[target].active = false
      @sprite[newTarget].active = true
      @sprite[newTarget].alpha = 1
      @sprite[newTarget].gotoAndPlay(0)
    if !target
      @sprite[0].play()
      @sprite[0].active = true
  restart:=>
    for sprite in @sprite
      sprite.active = false
      sprite.alpha = 0
      sprite.gotoAndStop(0)
    @sprite[0].alpha = 1
    @bgSprite.tint = '0xFFFFFF'
  animate:=>
    if @newColor
      for i in [0..2] by 1
        if Math.abs(@newColor[i] - @oldColor[i]) < Math.abs(@delta[i]) || @oldColor[i] < 0
          @oldColor[i] = @newColor[i]
        else 
          @oldColor[i] = Math.round(@oldColor[i] + @delta[i])
      @bgSprite.tint = random.rgbToHex @oldColor
      if @newColor[0] == @oldColor[0] && @newColor[2] == @oldColor[2] && @newColor[1] == @oldColor[1]  
        @newColor = false 

module.exports = Barra