angular.module('admin.controllers', [])
.controller('CreateQuestionController',
	function($scope, ParseService) {

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

			if ($scope.question.questionType == 0)
			{
				$scope.question.answerOptions = $scope.answerOptions;
			}
			else
			{
				$scope.question.answerOptions = ["Yes", "No"];
			}

			ParseService.createQuestion($scope.question).then(function() {
				console.log($scope.question);
			});
		};
	})
.controller('HomeController',
	function($scope) {

	});