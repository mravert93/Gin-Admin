class CreateQuestionController < ApplicationController

	require 'uri'
	require 'net/http'
	require 'net/https'


	def create

		createObject = params[:create_question]
		answersArray = []
		questionObject = {}

		createObject.each do |key, value|
			if key == "answerDictionary"
				answersArray = value
			else
				questionObject[key] = value
			end
		end
		
		uri = URI.parse("https://api.parse.com/1/classes/Question")
		answerUri = URI.parse("https://api.parse.com/1/classes/QuestionAnswers")

		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		answerHttps = Net::HTTP.new(answerUri.host, answerUri.port);
		answerHttps.use_ssl = true

		header = {
			'X-Parse-Application-Id' => 'KRsv5fl3h1k1qvRvhEQyITCnvIZ7eq8uJDJp9JRC',
	 		'X-Parse-REST-API-Key' => 'SrQRoGsr3Hse9VTXaFnOA6CsopZxx8UjIvlMIFNJ',
	 		'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Post.new(uri.path, header)
		request.body = questionObject.to_json

		response = https.request(request)

		responseData = JSON.parse(response.body)
		objectId = responseData["objectId"]

		answersArray.each do |answer|
			request = Net::HTTP::Post.new(answerUri.path, header)
			data = {
				'answer' => answer,
				'numAnswers' => 0,
				'questionId' => objectId
			}
			request.body = data.to_json

			response = answerHttps.request(request)
		end

		render json: response
	end
end
