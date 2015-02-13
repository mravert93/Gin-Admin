class CreateUserAnswersController < ApplicationController
	require 'parse_question'
	require 'parse_manager'
	require 'parse_answer'

	## gets all answers for the given question id
	def create 
		questionId = params[:questionId];
		answerId = params[:answerId];
		answer = params[:answer];

		success = ParseManager.createUserAnswer(answer, answerId, questionId);

		render json:success
	end
end