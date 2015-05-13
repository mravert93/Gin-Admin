class ParseQuestion
	attr_accessor :answer, :questionType, :questionWordings, :rounding

	## Define the initializer for a parse question
	def initialize(answer, question, questionType, questionWordings, answerType)
		@answer = answer
		@questionType = questionType
		@questionWordings = questionWordings
		@question = question
		@answerType = answerType ? answerType : 0
	end

	## Creates a new Question object from a json blob
	def self.questionFromJson(json)
		jsonQuestionType = json[:questionType]
		jsonAnswer = json[:answer]
		jsonQuestionWordings = json[:questionWordings]
		jsonQuestion = json[:question]
		jsonAnswerType = json[:answerType]

		new_question = ParseQuestion.new(jsonAnswer, jsonQuestion, jsonQuestionType, jsonQuestionWordings, jsonAnswerType)

		jsonRounding = json[:rounding]
		if (jsonRounding)
			new_question.rounding = jsonRounding.to_i;
		end

		new_question
	end

end