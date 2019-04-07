class Matraz

  constructor: (imgs, app) ->
    @app = app
    console.log 'new Desktop Matraz'
    @matrazSprite = new PIXI.Sprite.from(imgs[0])
    @liquidSprite = new PIXI.Sprite.from(imgs[1])
    @liquidSprite.x += 2
    @liquidSprite.tint = Math.random() * 0xFFFFFF
    @app.stage.addChild @liquidSprite
    @app.stage.addChild @matrazSprite
    @liquidSprite.buttonMode = true
    @liquidSprite.interactive = true
    # @matrazSprite.tint = Math.random() * 0xFFFFFF
module.exports = Matraz
