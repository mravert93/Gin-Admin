class ParseManager

	require 'uri'
	require 'net/http'
	require 'net/https'
	require 'cgi'

	private_class_method :new

	## Parse Api keys
  ##@PARSE_APP_ID = 'KRsv5fl3h1k1qvRvhEQyITCnvIZ7eq8uJDJp9JRC'
	##@PARSE_REST_KEY = 'SrQRoGsr3Hse9VTXaFnOA6CsopZxx8UjIvlMIFNJ'
	## QA Keys
	@PARSE_APP_ID = 'DoZASTALoss5wZIOd8SAJQSSjki4BBrQ2QyHClVr'
	@PARSE_REST_KEY = '7hWoKQa689ObInDuZq0x0S3J1RyOoXvV6ZsWoiVm'

	## Urls for Parse
	@QUESTION_URL = "https://api.parse.com/1/classes/Question"
	@ANSWER_URL = "https://api.parse.com/1/classes/QuestionAnswers"
	@USER_ANSWER_URL = "https://api.parse.com/1/classes/UserAnswer"
	@ADMIN_LOGIN_URL = "https://api.parse.com/1/login?"

	## Singleton constructor
	def ParseManager.instance
		@@manager = new unless @@manager
		@@manager
	end

	## Login the user to the admin system
	def self.adminLogin(username, password)
		queryHash = {:username => username, :password => password}

		uri = URI(@ADMIN_LOGIN_URL)
		uri.query = URI.encode_www_form(queryHash)

		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		header = {
			'X-Parse-Application-Id' => @PARSE_APP_ID,
	 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY
		}

		request = Net::HTTP::Get.new(uri.path << "?" << uri.query, header)

		response = https.request(request)

		responseData = JSON.parse(response.body)
	end

	## Send a question to the parse db
	def self.createQuestion(question)
		uri = URI.parse(@QUESTION_URL)

		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		header = {
			'X-Parse-Application-Id' => @PARSE_APP_ID,
	 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY,
	 		'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Post.new(uri.path, header)
		request.body = question.to_json

		response = https.request(request)

		responseData = JSON.parse(response.body)
	end

	## Send the answer for a question object
	def self.createQuestionAnswer(answer)
		uri = URI.parse(@ANSWER_URL)

		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		header = {
			'X-Parse-Application-Id' => @PARSE_APP_ID,
			'X-Parse-REST-API-Key' => @PARSE_REST_KEY,
			'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Post.new(uri.path, header)
		request.body = answer.to_json

		response = https.request(request)

		responseData = JSON.parse(response.body)
	end

	## Gets all questions
	def self.getAllQuestions()
		uri = URI.parse(@QUESTION_URL)

		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		header = {
			'X-Parse-Application-Id' => @PARSE_APP_ID,
			'X-Parse-REST-API-Key' => @PARSE_REST_KEY,
			'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Post.new(uri.path, header)

		response = https.request(request)
		puts response

		responseData = JSON.parse(response.body)
	end

end
