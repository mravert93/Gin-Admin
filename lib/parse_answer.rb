class ParseAnswer
	attr_reader :answer, :numAnswers, :questionId, :index

	## Define the initializer for a parse question
	def initialize(answer, questionId, index)
		@answer = answer
		@questionId = questionId
		@index = index
		@numAnswers = 0
	end

end