gsap = require 'gsap'
class StageEnd
  up: false
  constructor: (app, data, img) ->
    @app = app
    @data = data
    @box = new PIXI.Sprite.from(img)
    textStyle = new PIXI.TextStyle {
      fontSize: '5em'
      fontFamily: 'Gotham Rounded'
      align: 'center'
      fill: '0x2573B6'
    }
    @timeText = new PIXI.Text "Tiempo\n#{@data.tiempo}", textStyle
    @scoreText = new PIXI.Text "Pedidos\n#{@data.pedidos}", textStyle
    textStyle.fontSize = '6em'
    @congratsText = new PIXI.Text "¡Buen Trabajo!\n¡Sigue así!", textStyle
  
    @box.x = window.innerWidth/2 - @box.width/2
    @box.y = window.innerHeight
    @timeText.x = @box.x + 180
    @timeText.y = @box.y + 120
    @scoreText.x = @box.x + 650
    @scoreText.y = @box.y + 120
    @congratsText.x = @box.x + @box.width/2 - @congratsText.width/2
    @congratsText.y = @box.y + 475

    @box.interactive = true
    @box.buttonMode = true
    @box.on 'click', @moveDown
    @app.stage.addChild @box
    @app.stage.addChild @timeText
    @app.stage.addChild @scoreText
    @app.stage.addChild @congratsText
    # @moveUp()
  moveUp:=>
    tiempo = Math.round(@app.time/1000)
    mins = Math.floor(tiempo/60)
    if mins < 9 
      mins = "0#{mins}"
    tiempo = mins + ":" + tiempo%60
    @scoreText.text = "Pedidos\n#{@app.completos + 1}"
    @timeText.text = "Tiempo\n#{tiempo}"
    @app.completos = 0
    gsap.TweenMax.to(@box, 1.5, {y: 30})
    gsap.TweenMax.to(@timeText, 1.5, {y: 150})
    gsap.TweenMax.to(@scoreText, 1.5, {y: 150})
    gsap.TweenMax.to(@congratsText, 1.5, {y: 505})
  moveDown:=>
    s = window.innerHeight
    @app.stageComplete = false
    gsap.TweenMax.to(@box, 1.5, {y: s})
    gsap.TweenMax.to(@timeText, 1.5, {y: s + 120})
    gsap.TweenMax.to(@scoreText, 1.5, {y: s + 120})
    gsap.TweenMax.to(@congratsText, 1.5, {y: s + 475, onComplete: => @up = false})
module.exports = StageEnd