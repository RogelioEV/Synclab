gsap = require 'gsap'
$ = require 'jquery'
class Tubo
  scale:.5
  x: 0
  y: 0
  vertiendo: false
  constructor: (imgs, model, app) ->
    @app = app
    @model = model
    @scale = @model.scale

    @tuboSprite = new PIXI.Sprite.from(imgs[0])
    @tuboSprite.anchor.set 0.5
    
    @liquidSprite = new PIXI.Sprite.from(imgs[1])
    @liquidSprite.tint = @model.color
    @liquidSprite.anchor.set 0.5
    @responsiveScale = window.innerHeight/@tuboSprite.height
    @tuboSprite.interactive = @liquidSprite.interactive = true

    textStyle = new PIXI.TextStyle {
      fontSize: '3em'
      fontFamily: 'Gotham Rounded'
      align: 'center'
      fill: 'white'
    }

    @formula = @model.formula.replace(/(\d+)/g, "<sub>$1</sub>")
    @formula = "<div class='formula' id = #{@model.formula}>" + @formula + "</div>"
    $('body').append(@formula)
    @formulaText = $("##{@model.formula}")
    @formulaText.css('top', "#{@app.ui.box.y - @app.ui.box.height * 0.85}")
    @formulaText.css('left', "#{@app.ui.box.x - @app.ui.box.width * 0.40}")
    
    @nameText = new PIXI.Text "#{@model.nombre}", textStyle
    @nameText.anchor.set 0.5
    @nameText.x = window.innerWidth/2
    @nameText.y = window.innerHeight * .725
    @nameText.alpha = 0

    @app.stage.addChild @liquidSprite
    @app.stage.addChild @tuboSprite
    @app.stage.addChild @nameText

    @app.addAnimationNodes @
    
    @tuboSprite.on 'tap', @select
    @liquidSprite.on 'tap', @select
    window.addEventListener 'deviceorientation', @orientationEvt
    @app.socket.on 'liquido:completo', =>
      @app.vertiendo = false
      
  orientationEvt:(evt)=>
    beta = Math.round evt.beta    
    if beta > 140 || beta < 40 
      @verterLiquido()
    
  changePosition:(dir)=>
    newX = window.innerWidth/2 * @position 
    newScale = {}
    
    if @position == 1 
      newScale = 0.55
      gsap.TweenMax.to @formulaText, 0.5, {alpha: 1}
      
    else 
      newScale = 0.35
      gsap.TweenMax.to @formulaText, 0.5, {alpha: 0}
    gsap.TweenMax.to @, .5, {x:newX, scale:newScale}
  verterLiquido:=>
    if @app.selected && @position == 1 && !@app.vertiendo
      @app.socket.emit 'verter:sustancia', @model
      @app.vertiendo = true
      if @app.isTutorial && @model.nombre == 'Alcanfor'
        @app.socket.emit 'continuar:tutorial'
      return true
  select:=>
    return unless @position == 1
    gsap.TweenMax.to @, 0.5, {scale: 0.65}
    if @app.selected 
      @verterLiquido()
    else 
      @app.ui.changeArrow()
    @app.selected = true
    # @tuboSprite.interactive = @liquidSprite.interactive = false
    gsap.TweenMax.to @nameText, 0.5, {alpha: 1}

  deselect:=>
    gsap.TweenMax.to @, 0.5, {scale: 0.50}
    gsap.TweenMax.to @nameText, 0.5, {alpha: 0}
    @app.ui.changeArrow()
    @app.selected = false
    @tuboSprite.interactive = @liquidSprite.interactive = true

  animate:=>
    @tuboSprite.x = @x
    @tuboSprite.y = @y
    @liquidSprite.x = @x
    @liquidSprite.y = @y
    @liquidSprite.scale.x = @scale * @responsiveScale
    @liquidSprite.scale.y = @scale * @responsiveScale
    @tuboSprite.scale.x = @scale * @responsiveScale
    @tuboSprite.scale.y = @scale * @responsiveScale

    # @matrazSprite.tint = Math.random() * 0xFFFFFF
module.exports = Tubo