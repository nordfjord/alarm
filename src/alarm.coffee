m = require 'mithril'
moment = require 'moment'
timepicker = require './timepicker.coffee'

Alarm = ->
	alarm = {}
	alarm.timeout = 0
	alarm.controller = ->
		# return an object containing only an onunload function
		# there strictly isn't a need for this
		# but when creating larger apps it's important to clean up
		# intervals, and timeouts between routes
		onunload: ()->
			window.clearInterval alarm.interval

	alarm.currentTime = do moment
	# we want to save the link to local storage so that our alarm clock
	# remembers the last alarm sound, the default is an awful sound on youtube
	alarm.link = m.prop window.localStorage.link || 'https://www.youtube.com/watch?v=SlZMVAydqaE'
	# setting the default values to 1 minutes past now is a great testing tool
	alarm.hour = m.prop moment().get 'hour'
	alarm.minute = m.prop (moment().get 'minute') + 1

	# since chrome and other popular browsers don't let us 
	# open popups except on user events we need to use the current window
	# to open the link
	alarm.ring = ->
		window.location = do alarm.link

	alarm.start = ->
		val = do moment
		val.set 'hours', do alarm.hour
		val.set 'minutes', do alarm.minute
		val.set 'seconds', 0
		val.set 'milliseconds', 0

		val.add 1, 'days' if val.isBefore do moment

		alarm.ringAt = val
		# if alarm was already set we need to clear the timeout
		window.clearTimeout alarm.timeout if alarm.timeout
		alarm.timeout = window.setTimeout alarm.ring, val - moment()
	
	# we want to update our app every second to show time progressing
	alarm.interval = window.setInterval ->
		m.startComputation()
		alarm.currentTime = moment()
		if alarm.ringAt
			dur = moment.duration alarm.ringAt - moment()
			hours = dur.get 'hours'
			minutes = dur.get 'minutes'
			seconds = dur.get 'seconds'
			alarm.timeTo = "#{hours} Hours, #{minutes} Minutes, and #{seconds} Seconds"
		m.endComputation()
	, 1000

	textalign =
		style: 
			'text-align': 'center'
			cursor: 'pointer'

	alarm.view = ->
		m '.row', [
			m '.col-md-6.col-md-push-3', [
				m '.panel.panel-default', [
					m '.panel-heading', 'Alarm Settings'
					m '.panel-body', [
						m 'h1', style: 'text-align': 'center', alarm.currentTime.format 'HH:mm:ss'
						m '.label-wrapper', style: 'width: 100%; text-align: center;', [
							m 'label', 'Alarm time'
						]
						m.component timepicker, hour: alarm.hour, minute: alarm.minute
						m 'label', 'Link'
						m 'input[type=text].form-control',
							value: do alarm.link
							oninput: m.withAttr 'value', (val)->
								window.localStorage.link = val
								alarm.link val
						(m 'h3', "#{alarm.timeTo} to alarm") if alarm.timeTo
					]
					m '.panel-footer', style: 'min-height': '54px', [
						m 'button[type=button].btn.btn-success.pull-right',
							onclick: alarm.start
						, 'Start'
					]
				]
			]
		]

	alarm

module.exports = Alarm
