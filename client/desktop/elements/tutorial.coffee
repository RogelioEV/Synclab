$ = require 'jquery'
gsap = require 'gsap'
class Tutorial

  constructor: (app) ->
    @app = app
    @step = 1
    @container = '<div class="tutoContainer"></div>'
    $('body').append(@container)
    @container = $('.tutoContainer')
    @changeInfo()
    @app.socket.on 'continuar:tutorial', @changeInfo
  show:=>
    gsap.TweenMax.to @container, 0.5, {opacity: 1}
  hide:=>
    gsap.TweenMax.to @container, 0.5, {opacity: 0}
  changeInfo:()=>
    @hide()
    hide = false
    switch @step
      when 1
        @info = '
          <h3> ¡Bienvenido/a a Synclab!</h3>
          <br>
          <p>En este juego, nuestro objetivo es completar los pedidos que encuentras a tu izquierda, en el menor tiempo posible.</p>'
      when 2
        @info = '<p>Si quieres lograrlo, tendrás que mezclar sustancias en el matraz. </p>
          <p>En la parte derecha de la pantalla podrás encontrar la receta del pedido actual, que te dirá qué elementos necesitas mezclar para crear perfume, jabón, insecticida o alka-seltzer</p>'
      when 3
        @info = '<p>Para comenzar, harás un poco de perfume. En tus sustancias deslizate hasta que encuentres C<sub>10</sub>H<sub>16</sub>O, que es la formula del Alcanfor, nuestro primer ingrediente.
        <p> Una vez que lo encuentres, haz tap en él para seleccionarlo, y gira lentamente to celular para vertirlo.</p>'
        @app.socket.emit 'ocultar:continuar'
      when 4
        @hide()
        @app.socket.emit 'mostrar:continuar'
        hide = true
      when 5
        @info = '<p>Ahora solo busca las demás sustancias que requiere el pedido. No olvides que si llegas a equivocarte el icono de bote de basura en tu teléfono puede ayudarte a reiniciar un pedido.'
      when 6
        @info = '<h3> ¡Mucha suerte! </h3>'
      when 7
        @app.socket.emit 'terminar:tutorial'
        @hide()
        hide = true
    @container.html(@info)
    if !hide then @show()
    @step++
module.exports = Tutorial