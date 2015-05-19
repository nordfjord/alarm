m = require 'mithril'
moment = require 'moment'

Alarm = ->
	alarm = {}
	alarm.controller = ->
		ctrl = 
			currentTime: moment()
			link: m.prop ''

		ringAlarm = ->
			window.open ctrl.link(), '_blank'

		ctrl.timeSelected = (value)->
			val = moment()
			[hours, minutes] = value.split ':'
			val.set 'hours', hours
			val.set 'minutes', minutes
			val.set 'seconds', 0
			val.set 'milliseconds', 0

			val.add 'days', 1 if val.isBefore moment()
			ctrl.selectedTime = val
			console.log("timeout #{val-(+moment())}")
			window.setTimeout ringAlarm, val-(+moment())
		
		window.setInterval ->
			m.startComputation()
			ctrl.currentTime = moment()
			if ctrl.selectedTime
				ctrl.timeToAlarm = moment.duration((+moment())-ctrl.selectedTime).humanize()
			m.endComputation()
		, 1000

		return ctrl

	alarm.view = (ctrl)->
		m 'body', [
			m 'h1', ctrl.currentTime.format 'LLL'
			m 'label', 'Alarm time'
			m 'input[type=time]',
				onblur: m.withAttr 'value', ctrl.timeSelected
			m 'label', 'Link'
			m 'input[type=text]',
				oninput: m.withAttr 'value', ctrl.link
			(m 'h3', "#{ctrl.timeToAlarm} to alarm") if ctrl.timeToAlarm
		]

	alarm

module.exports = Alarm
