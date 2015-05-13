angular.module('admin.controllers', [])
.controller('CreateQuestionController',
	function($scope, ParseService, $route) {

		$scope.question = {}
		$scope.questionWordings = [];
		$scope.answerOptions = [];
		$scope.yesAnswer;
		$scope.noAnswer;
		$scope.rounding;

		// Question type array
		$scope.questionTypes = [
			{ id : 0, title : 'Multiple Choice - 0'},
			{ id : 1, title : 'Yes / No - 1'},
			{ id : 2, title : 'Monetary - 2'},
			{ id : 3, title : 'Date / Time - 3'},
			{ id : 4, title : 'Generic Numeric (No Units) - 4'}
		];
		$scope.selectedQuestionType = $scope.questionTypes[0];

		$scope.submitQuestion = function()
		{
			$scope.question.questionType = $scope.selectedQuestionType.id;
			$scope.question.questionWordings = $scope.questionWordings;
			var answerDictionary = [];
			var alternateAnswers = [];
			
			switch ($scope.question.questionType)
			{
				case 0:
					answerDictionary = $scope.answerOptions
					break;
				case 1:
					answerDictionary = ["Yes", "No"];
					alternateAnswers.push($scope.yesAnswer);
					alternateAnswers.push($scope.noAnswer);
					break;
				case 2:
				case 3:
				case 4:
					// Set the answer to use the number pad
					$scope.question.answerType = 1;
					$scope.question.rounding = $scope.rounding;
					break;
				default:
					break;
			}

			$scope.question.answerDictionary = answerDictionary;
			$scope.question.alternateAnswers = alternateAnswers;

			console.log($scope.question);

			ParseService.createQuestion($scope.question).then(function(response) {
				console.log(response.data);
				$route.reload();
			});

		};
	})
.controller('LoginController',
	function($scope, ParseService, $route, $location, $rootScope, $cookieStore) {
		if ($cookieStore.get("sessionToken") != null)
		{
			$cookieStore.remove("sessionToken");
		}

		$scope.login = function()
		{
			ParseService.loginAdmin($scope.username, $scope.password).then(function(response) {
				if (response.data.sessionToken)
				{
					$rootScope.loggedUser = response.data.objectId;
					$cookieStore.put("sessionToken", response.data.sessionToken);
					$location.path("/");
				}
				else
				{
					console.log(response.data.error);
				}
			})
		}
	})
.controller('CreateUserAnswerController',
	function($scope, ParseService, $route) {

		$scope.questions = []; 
		$scope.selectedQuestion = {};
		$scope.selectedAnswer = {};
		$scope.answers = [];
		$scope.numAnswers;
		$scope.createdAnswer;
		$scope.errors;

		ParseService.getAllQuestions().then(function(response) {
			if (response.data.results)
			{
				$scope.questions = response.data.results;
			}
			else
			{
				console.log(response.data)
			}		
		});

		$scope.updateAnswers = function() {
			console.log($scope.selectedQuestion.objectId);
			ParseService.getAnswersForQuestion($scope.selectedQuestion.objectId).then(function(response) {
				$scope.answers = response.data;
			});
		}

		$scope.submitAnswer = function() {
			answer = $scope.selectedAnswer.answer;
			answerId = $scope.selectedAnswer.objectId;
			questionId = $scope.selectedQuestion.objectId;
			numAnswers = $scope.numAnswers;
			createdAnswer = $scope.createdAnswer;

			if (!(createdAnswer == null) && !(answerId == null))
			{
				$scope.errors = 'Cannot choose an answer and create a new one!';
			}
			else if (answerId != null)
			{
				ParseService.createUserAnswer(answer, answerId, questionId, numAnswers).then(function(response) {
					console.log(response.data);
					$route.reload();
				})
			}
			else if (createdAnswer != null)
			{
				ParseService.createAnswerForQuestion(createdAnswer, questionId, $scope.answers.length, numAnswers).then(function(response) {
					console.log(response.data);
					$route.reload();
				})
			}
		}
	})
.controller('HomeController',
	function($scope) {

	});
