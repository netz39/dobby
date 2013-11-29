
should = require('should')
http = require('http')

describe 'webserver', ->
	app = require('../app.coffee')
	port = process.env.PORT || 3000
	it 'should answer on GET / port 3000 or process.env.PORT', (done) ->
		http.get 'http://localhost:'+port+"/", (res) ->
			res.statusCode.should.be.below(400)
			res.on 'data', (data) ->
				data.should.not.be.empty
				done()

	it 'should answer on GET /raw port 3000 or process.env.PORT', (done) ->
		http.get 'http://localhost:'+port+"/raw", (res) ->
			res.statusCode.should.be.below(400)
			res.on 'data', (data) ->
				data.should.not.be.empty
				done()

		
