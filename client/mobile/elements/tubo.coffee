gsap = require 'gsap'

class Tubo
  scale:.5
  x: 0
  y: 0
  constructor: (imgs, model, app) ->
    @app = app
    @model = model
    @scale = @model.scale
    @tuboSprite = new PIXI.Sprite.from(imgs[0])
    @liquidSprite = new PIXI.Sprite.from(imgs[1])
    @liquidSprite.tint = @model.color
    @liquidSprite.anchor.set 0.5
    @tuboSprite.anchor.set 0.5
    @app.stage.addChild @tuboSprite
    @app.stage.addChild @liquidSprite
    @app.addAnimationNodes @
  changePosition:(dir)=>
    if dir
      if @position == 0 
        newX = window.innerWidth/2
        scale = 0.4
        @position = 1
      else if @position == 1
        newX = window.innerWidth
        scale = 0.3
        @position = 2
      else if @app.tubos.lenght - @position == 1
          @x = -@liquidSprite.window/2
          newX = window.innerWidth/2
    gsap.TweenMax @, 1, {x:newX, scale}
  animate:=>
    @tuboSprite.x = @x
    @tuboSprite.y = @y
    @liquidSprite.x = @x
    @liquidSprite.y = @y
    @liquidSprite.scale.x = @scale
    @liquidSprite.scale.y = @scale
    @tuboSprite.scale.x = @scale
    @tuboSprite.scale.y = @scale

    # @matrazSprite.tint = Math.random() * 0xFFFFFF
module.exports = Tubo