gsap = require 'gsap'
class Ui
  box: null
  backArrow: null
  trashCan: null

  constructor: (app, imgArr) ->
    @app = app
    @box = new PIXI.Sprite.from imgArr[0]
    @box.anchor.set 0.5,1
    @box.x = window.innerWidth/2
    @box.y = window.innerHeight * .95
    @responsiveScale = window.innerWidth/@box.width    
    @box.scale.x = 1 * @responsiveScale
    @box.scale.y = 1 * @responsiveScale

    @backArrow = new PIXI.Sprite.from imgArr[1]
    @backArrow.x = window.innerWidth * .05
    @backArrow.y = @box.y - @backArrow.height * .4
    @backArrow.interactive = true
    @responsiveScale = window.innerWidth/@backArrow.width 
    @backArrow.scale.x = .15 * @responsiveScale
    @backArrow.scale.y = .15 * @responsiveScale

    @trashCan = new PIXI.Sprite.from imgArr[2]
    @trashCan.anchor.set 1,0
    @trashCan.x = window.innerWidth * .95
    @trashCan.y = @box.y - @trashCan.height * .4
    @trashCan.interactive = true
    @responsiveScale = window.innerWidth/@trashCan.width  
    @trashCan.scale.x = .10 * @responsiveScale
    @trashCan.scale.y = .10 * @responsiveScale

    @app.stage.addChild @box
    @app.stage.addChild @backArrow
    @app.stage.addChild @trashCan

    @backArrow.on 'tap', @goBack
    @trashCan.on 'tap', @restart
    
    @changeArrow()
  
  changeArrow:=>
    gsap.TweenMax.to @backArrow, 0.5, {alpha: 1 - @backArrow.alpha}
    @backArrow.interactive = !@backArrow.interactive

  goBack:=>
    @app.goBack()

  restart:=>
    @app.socket.emit 'reiniciar:mezcla'

module.exports = Ui