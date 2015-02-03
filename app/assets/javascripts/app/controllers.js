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
				console.log(response);
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
.controller('HomeController',
	function($scope) {

	});
