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

# Method to get the question id based on the given question name
def getQuestionId(question_name)
	query_params = {:question => question_name}
	query_hash = {:where => query_params.to_json}

	uri = URI(@QUESTION_URL)
	uri.query = URI.encode_www_form(query_hash)
	puts uri.query

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

# Method to get the answer id of the given answer name based on the question id
def getAnswerId(answer_name, question_id)
	query_params = {:answer => answer_name, :questionId => question_id}
	query_hash = {:where => query_params.to_json}

	uri = URI(@ANSWER_URL)
	uri.query = URI.encode_www_form(query_hash)
	puts uri.query

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

# Increments the counter on the answer table
def incrementAnswerCount(answerId)
	incrementHash = {"__op" => "Increment", "amount" => 1}
	data = {:numAnswers => incrementHash}

	uri = URI.parse(@ANSWER_URL)

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true

	header = {
		'X-Parse-Application-Id' => @PARSE_APP_ID,
 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY,
 		'Content-Type' => 'application/json'
	}

	request = Net::HTTP::Put.new(uri.path << "/" << answerId, header)
	request.body = data.to_json

	response = https.request(request)

	responseData = JSON.parse(response.body)
end

# Create an answer for an unknown user
def createUserAnswer(answer, answerId, questionId, attrs_hash)
	## increment the number of answers on the answer object
	incrementAnswerCount(answerId);

	data = {:answer => answer, :answerId => answerId, :questionId => questionId, :userId => "From_CSV_Survey_1"}

	attrs_hash.each do |key, value|
		data[key] = value
	end

	uri = URI.parse(@USER_ANSWER_URL)

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true

	header = {
		'X-Parse-Application-Id' => @PARSE_APP_ID,
 		'X-Parse-REST-API-Key' => @PARSE_REST_KEY,
 		'Content-Type' => 'application/json'
	}

	request = Net::HTTP::Post.new(uri.path, header)
	request.body = data.to_json

	response = https.request(request)

	responseData = JSON.parse(response.body)
	puts responseData
end

def getGenderIndex(gender)
	if gender.eql? "Male"
		return 1
	elsif gender.eql? "Female"
		return 2
	else
		return 3
	end
end

def getAge(birthdate_string)
	begin
		birthdate = Date.strptime(birthdate_string, "%m-%d-%Y")
		now = Time.now.utc.to_date
		now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
	rescue
		return nil
	end
end

def getLocationInfo(residence)
	info = Geocoder.search(residence)
	unless info.nil?
		info.first
	end
end

file_name = ARGV[0]

question_dict = {}

answers_array = CSV.read(file_name)

# define all of the indices
question_index = 0
gender_index = 0
birthdate_index = 0
location_index = 0

for col in answers_array[0]
	unless col.nil?
		puts col
		if col.include? "Timestamp"
			# Do nothing
		elsif col.include? "Please"
			if col.include? "gender"
				gender_index = question_index
				birthdate_index = gender_index + 1
				location_index = gender_index + 2
			end
		else
			question_info = getQuestionId(col)
			unless question_info[0].nil?
				object_id = question_info[0]["objectId"]
				question_dict[question_index] = object_id
			end
		end
	end
	question_index += 1
end

csv_row_index = 1
while csv_row_index < answers_array.length do
	puts "------------ Uploading Row #{csv_row_index} --------------------------"
	row_array = answers_array[csv_row_index]
	unless row_array.nil?
		column_index = 0

		# Get the user's gender, birthdate and location
		gender = row_array[gender_index]
		birthdate = row_array[birthdate_index]
		location = row_array[location_index]

		unless gender.nil?
			gender_enum = getGenderIndex(gender)
		end
		unless birthdate.nil?
			age = getAge(birthdate)
		end
		unless location.nil?
			location_info = getLocationInfo(location)
		end

		residence = nil
		latitude = nil
		longitude = nil

		# Set the residency if we found it okay
		unless location_info.nil?
			unless location_info.city.nil? or location_info.state.nil?
				residence = location_info.city << ', ' << location_info.state
			end
			unless location_info.coordinates.nil?
				latitude = location_info.coordinates[0]
				longitude = location_info.coordinates[1]
			end
		end

		attrs_hash = {}
		unless gender_enum.nil?
			attrs_hash[:gender] = gender_enum
		end
		unless age.nil?
			attrs_hash[:age] = age
		end
		unless residence.nil?
			attrs_hash[:residence] = residence
		end
		unless latitude.nil?
			attrs_hash[:latitude] = latitude
		end
		unless longitude.nil?
			attrs_hash[:longitude] = longitude
		end

		# Row is not nil so loop through each column
		for col in row_array
			puts col
			unless col.nil?
				question_id = question_dict[column_index]
				if question_id.nil?
					# Do nothing for now
				else
					answer_info = getAnswerId(col, question_id)
					unless answer_info[0].nil?
						object_id = answer_info[0]["objectId"]
						createUserAnswer(col, object_id, question_id, attrs_hash)
						puts 'Created answer!'
					end
				end
			end

			# increment column index
			column_index += 1
		end
	end
	csv_row_index += 1
end

