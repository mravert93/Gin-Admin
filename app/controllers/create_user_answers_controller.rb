class CreateUserAnswersController < ApplicationController
	require 'parse_question'
	require 'parse_manager'
	require 'parse_answer'

	## gets all answers for the given question id
	def create 
		questionId = params[:questionId]
		answerId = params[:answerId]
		answer = params[:answer]
		numAnswers = params[:numAnswers].to_i

		begin
			success = ParseManager.createUserAnswer(answer, answerId, questionId)
			numAnswers -= 1
		end until numAnswers == 0

		render json:success
	end
end