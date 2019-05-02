Sustancias  = require '../../mobile/data/substances.JSON'
Pedidos     = require '../data/pedidos.JSON'
gsap = require 'gsap'
$ = require 'jquery'
class Recipie

  constructor: (type, app, img) ->
    @app = app
    @type = type
    switch type
      when 0
        @name = 'Perfume'
        @ingredientes = Pedidos['perfume']['ingredientes']
      when 1
        @name = 'Alka-Seltzer'
        @ingredientes = Pedidos['alkaseltzer']['ingredientes']
      when 2
        @name = 'Jabón'
        @ingredientes = Pedidos['jabon']['ingredientes']
      when 3
        @name = 'Insecticida'
        @ingredientes = Pedidos['insecticida']['ingredientes']
    @text = "<div class='receta' id = #{@type}>Para crear <b>#{@name}</b> se necesita<br><ul class='ingredientes'>"
    for ingrediente in @ingredientes
      for name, val of ingrediente
        for sustancia, data of Sustancias
          if name == data.nombre
            @text += "<li>#{name}(#{data.formula.replace(/(\d+)/g, "<sub>$1</sub>")})</li>"
    @text += "</ul> </div>"
    $('body').append(@text)
    @tuto = $("##{@type}")
  mostrar:=>
    gsap.TweenMax.to @tuto, .5, {alpha:1}
  ocultar:=>
    gsap.TweenMax.to @tuto, .5, {alpha: 0}
module.exports = Recipie