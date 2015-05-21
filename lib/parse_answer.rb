class ParseAnswer
	attr_accessor :answer, :numAnswers, :questionId, :index, :type

	## Define the initializer for a parse question
	def initialize(answer, questionId, index, alternateAnswer)
		@answer = answer
		@questionId = questionId
		@index = index
		@numAnswers = 0
		@alternateAnswer = alternateAnswer
		@type = 0
	end

end