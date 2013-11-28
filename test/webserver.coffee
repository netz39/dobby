
should = require('should')
http = require('http')

describe 'webserver', ->
	it 'should answer on port 3000 or process.env.PORT', (done) ->
		app = require('../app.coffee')
		port = process.env.PORT || 3000
		http.get 'http://localhost:'+port+"/", (res) ->
			res.on 'data', (data) ->
				data.should.not.be.empty
				done()

		
