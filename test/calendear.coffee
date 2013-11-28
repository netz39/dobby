calendar = require('../calendar.coffee')
timers = require('timers')

describe 'calendar.coffee', ->
	describe 'Calendar', ->
		it 'should fetch ical events', (done) ->
			cal = new calendar.Calendar(process.env.DOBBY_ICAL_URL)
			test = () ->
				cal.events.should.not.be.empty
				done()
			timers.setTimeout(test, 500)
			
	describe 'CalendarEvent', ->
		it 'should implement start, name, description and summary', ->
			d = new Date()
			e = new calendar.CalendarEvent("foobar", d)
			e.start.should.equal d
			e.name.should.equal "foobar"
