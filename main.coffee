m = require 'mithril'
Alarm = require './src/alarm.coffee'


app = Alarm()

m.mount document.body, app
