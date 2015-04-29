class CreateQuestionAnswersController < ApplicationController
	require 'parse_question'
	require 'parse_manager'
	require 'parse_answer'

	## gets all answers for the given question id
	def create 
		question_id = params[:questionId]
		answer = params[:answer]
		index = params[:answerIndex]
		num_answers = Integer(params[:numAnswers])

		parseAnswer = ParseAnswer.new(answer, question_id, index, '')
		puts parseAnswer.numAnswers
		parseAnswer.numAnswers = num_answers

		response = ParseManager.createQuestionAnswer(parseAnswer)

		render json: response
	end

	# Gets all of the answers for the given question id
	def index
		questionId = params[:questionId];

		answers = ParseManager.getAnswersForQuestion(questionId);
		results_array = answers['results']

		# make the answers into integers if that is what they are
		begin
			results_array.map {|answr| answr['answer'] = Integer(answr['answer'])}
		rescue
			puts 'Cannot be converting into integers'
			# do nothing
		end

		# sort all of the answers
		sorted_answers = results_array.sort {|a,b| a['answer'] <=> b['answer']}

		render json:sorted_answers
	end
end