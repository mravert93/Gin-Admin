angular.module('admin.controllers', [])
.controller('CreateQuestionController',
	function($scope, ParseService, $route) {

		$scope.question = {}
		$scope.questionWordings = [];
		$scope.answerOptions = [];

		// Question type array
		$scope.questionTypes = [
			{ id : 0, title : 'Multiple Choice - 0'},
			{ id : 1, title : 'Yes / No - 1'}
		];
		$scope.selectedQuestionType = $scope.questionTypes[0];

		$scope.submitQuestion = function()
		{
			$scope.question.questionType = $scope.selectedQuestionType.id;
			$scope.question.questionWordings = $scope.questionWordings;
			var answerDictionary = [];

			if ($scope.question.questionType == 0)
			{
				answerDictionary = $scope.answerOptions
			}
			else
			{
				answerDictionary = ["Yes", "No"];
			}

			$scope.question.answerDictionary = answerDictionary;

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
				$scope.answers = response.data.results;
			});
		}

		$scope.submitAnswer = function() {
			answer = $scope.selectedAnswer.answer;
			answerId = $scope.selectedAnswer.objectId;
			questionId = $scope.selectedQuestion.objectId;
			numAnswers = $scope.numAnswers;

			ParseService.createUserAnswer(answer, answerId, questionId, numAnswers).then(function(response) {
				console.log(response.data);
				$route.reload();
			})
		}
	})
.controller('HomeController',
	function($scope) {

	});
