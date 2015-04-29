require 'csv'
require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'
require 'json'
require 'geocoder'

## Parse Api keys
@PARSE_APP_ID = 'KRsv5fl3h1k1qvRvhEQyITCnvIZ7eq8uJDJp9JRC'
@PARSE_REST_KEY = 'SrQRoGsr3Hse9VTXaFnOA6CsopZxx8UjIvlMIFNJ'
## QA Keys
# @PARSE_APP_ID = 'DoZASTALoss5wZIOd8SAJQSSjki4BBrQ2QyHClVr'
# @PARSE_REST_KEY = '7hWoKQa689ObInDuZq0x0S3J1RyOoXvV6ZsWoiVm'

## Urls for Parse
@QUESTION_URL = "https://api.parse.com/1/classes/Question"
@ANSWER_URL = "https://api.parse.com/1/classes/QuestionAnswers"
@USER_ANSWER_URL = "https://api.parse.com/1/classes/UserAnswer"

# Method to get the answer id of the given answer name based on the question id
def deleteAnswer(answer_id)

	uri = URI(@USER_ANSWER_URL)

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true

	header = {
		'X-Parse-Application-Id' => @PARSE_APP_ID,
 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY
	}

	request = Net::HTTP::Delete.new(uri.path << "/" << answer_id, header)

	response = https.request(request)

	response_data = JSON.parse(response.body)
	response_data["results"]
end

# Method to get the answer id of the given answer name based on the question id
def getAllAnswersForUser(user_id)
	query_params = {:userId => user_id}
	query_hash = {:where => query_params.to_json}

	uri = URI(@USER_ANSWER_URL)
	uri.query = URI.encode_www_form(query_hash)

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true

	header = {
		'X-Parse-Application-Id' => @PARSE_APP_ID,
 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY
	}

	request = Net::HTTP::Get.new(uri.path << "?" << uri.query, header)

	response = https.request(request)

	response_data = JSON.parse(response.body)
	response_data["results"]
end

results = getAllAnswersForUser("From_CSV_Survey_1")

# Loop through all of the results and delete the answers
results.each do |answer_object|
	object_id = answer_object["objectId"]
	puts "Deleting Answer " << object_id
	deleteAnswer(object_id)
	puts "Answer Deleted"
end