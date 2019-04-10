$ = require 'jquery'
io = require 'socket.io-client'
Mobile = require './mobile/indexMobile'
Desktop = require './desktop/indexDesktop'

$(document).ready(=>
  if window.location.pathname == '/mobile'
    new Mobile()
  if window.location.pathname == '/desktop'
    new Desktop()
)
