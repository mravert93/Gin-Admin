class ParseQuestion
	attr_reader :answer, :questionType, :questionWordings

	## Define the initializer for a parse question
	def initialize(answer, question, questionType, questionWordings)
		@answer = answer
		@questionType = questionType
		@questionWordings = questionWordings
		@question = question
	end

	## Creates a new Question object from a json blob
	def self.questionFromJson(json)
		jsonQuestionType = json[:questionType]
		jsonAnswer = json[:answer]
		jsonQuestionWordings = json[:questionWordings]
		jsonQuestion = json[:question]

		ParseQuestion.new(jsonAnswer, jsonQuestion, jsonQuestionType, jsonQuestionWordings)
	end

end