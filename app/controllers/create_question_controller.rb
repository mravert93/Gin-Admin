class CreateQuestionController < ApplicationController

	require 'uri'
	require 'net/http'
	require 'net/https'


	def create
		uri = URI.parse("https://api.parse.com/1/classes/Question")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		header = {
			'X-Parse-Application-Id' => 'KRsv5fl3h1k1qvRvhEQyITCnvIZ7eq8uJDJp9JRC',
	 		'X-Parse-REST-API-Key' => 'SrQRoGsr3Hse9VTXaFnOA6CsopZxx8UjIvlMIFNJ',
	 		'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Post.new(uri.path, header)
		request.body = params

		response = https.request(request)

		render json: response
	end
end