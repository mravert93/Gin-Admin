class ParseAnswer
	attr_accessor :answer, :numAnswers, :questionId, :index

	## Define the initializer for a parse question
	def initialize(answer, questionId, index, alternateAnswer)
		@answer = answer
		@questionId = questionId
		@index = index
		@numAnswers = 0
		@alternateAnswer = alternateAnswer
	end

end