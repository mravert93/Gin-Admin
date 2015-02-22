class CreateQuestionController < ApplicationController

	require 'parse_question'
	require 'parse_manager'
	require 'parse_answer'


	def create
		createObject = params[:create_question]
		answersArray = []
		alternateAnswersArray = []

		question = ParseQuestion.questionFromJson(createObject)

		createObject.each do |key, value|
			if key == "answerDictionary"
				answersArray = value
			elsif key == "alternateAnswers"
				alternateAnswersArray = value
			end
		end

		response = ParseManager.createQuestion(question)

		objectId = response["objectId"]

		answerIndex = 0
		answersArray.each do |answer|
			altAnswer = alternateAnswersArray[answerIndex]
			if (altAnswer)
				parseAnswer = ParseAnswer.new(answer, objectId, answerIndex, altAnswer)
			elsif
				parseAnswer = ParseAnswer.new(answer, objectId, answerIndex, '')
			end

			answerIndex += 1

			response = ParseManager.createQuestionAnswer(parseAnswer)
		end

		render json: response
	end

	## Gets all questions
	def index
		questions = ParseManager.getAllQuestions();

		render json:questions
	end

end
