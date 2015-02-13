class CreateQuestionAnswersController < ApplicationController
	require 'parse_question'
	require 'parse_manager'
	require 'parse_answer'

	## gets all answers for the given question id
	def create 
		questionId = params[:questionId];

		answers = ParseManager.getAnswersForQuestion(questionId);

		render json:answers
	end
end