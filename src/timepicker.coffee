m = require 'mithril'
moment = require 'moment'

zeroPad = (val)->
	if typeof val is 'string'
		val = parseInt val
	if val < 10
		'0' + val
	else
		val

timepicker = 
	controller: (args)->
		ctrl =
			hour: args.hour or m.prop moment().get 'hour'
			minute: args.minute or m.prop moment().get 'minute'
			up: (type)->
				->
					val = do ctrl[type]
					mod = if type is 'hour' then 24 else 60
					val = ++val % mod
					ctrl[type] val
			down: (type)->
				->
					val = do ctrl[type]
					mod = if type is 'hour' then 24 else 60
					val = ((--val % mod) + mod) % mod
					ctrl[type] val
	view: (ctrl, args)->
		m 'table.timepicker', [
			m 'tbody', [
				m 'tr', [
					m 'td.align', onclick: ctrl.up('hour'), m 'i.glyphicon.glyphicon-chevron-up'
					m 'td'
					m 'td.align', onclick: ctrl.up('minute'), m 'i.glyphicon.glyphicon-chevron-up'
				]
				m 'tr', [
					m 'td', style: width: '45px', m 'input.form-control',
						value: zeroPad do ctrl.hour
						oninput: m.withAttr 'value', (val)->
							val = parseInt val
							val = 0 if val < 0
							val = 23 if val > 23
							ctrl.hour val
					m 'td', style: 'text-align': 'center', ':'
					m 'td', style: width: '45px', m 'input.form-control',
						value: zeroPad do ctrl.minute
						oninput: m.withAttr 'value', (val)->
							val = parseInt val
							val = 0 if val < 0
							val = 59 if val > 59
							ctrl.minute val
				]
				m 'tr', [
					m 'td.align', onclick: ctrl.down('hour'), m 'i.glyphicon.glyphicon-chevron-down'
					m 'td'
					m 'td.align', onclick: ctrl.down('minute'), m 'i.glyphicon.glyphicon-chevron-down'
				]
			]
		]

module.exports = timepicker
