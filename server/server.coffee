express = require('express')
device = require 'express-device'
webpack = require 'webpack'
webpackDevMiddleware = require 'webpack-dev-middleware'
webpackHotMiddleware = require 'webpack-hot-middleware'
sha1 = require 'sha1'

config = require '../webpack.config.server'
compiler = webpack(config)
app     = express()

app.use device.capture()

app.use webpackDevMiddleware compiler,
  publicPath: config.output.publicPath
  stats: {colors: true}

app.use webpackHotMiddleware compiler,
    log: console.log

app.set('view engine', 'pug')

app.get '/',  (req, res) ->
  browser = req.device.type
  console.log browser
  if browser == 'desktop' then res.redirect '/desktop'
  else res.redirect '/mobile'

app.get '/mobile', (req, res) =>
  browser = req.device.type
  if browser != 'desktop'
    res.render './mobile/indexMobile'
  else res.redirect '/'
app.get '/get', (req, res) =>
  res.render './mobile/indexMobile'
app.get '/desktop', (req, res) =>
  browser = req.device.type
  ip = req.connection.remoteAddress
  if browser == 'desktop'
    res.render './desktop/index', {
      browser,
      code: sha1(ip).substring(0, 4)
    }
  else res.redirect '/'


module.exports = app
