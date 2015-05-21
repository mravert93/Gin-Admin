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
			if key == "answerDictionary" and value
				answersArray = value
			elsif key == "alternateAnswers" and value
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

			# Set the answer type if they are in the unknown category
			if answer.include? "Don't Know" and question.questionType > 1
				parseAnswer.type = 1
			elsif answer.include? "Not Applicable" and question.questionType > 1
				parseAnswer.type = 2
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
