angular.module('admin.services', [])
.service('ParseService',
	function($http, $q) {

		this.createQuestion = function(question) {
			var d = $q.defer();

			$http({
				method: 'POST',
				url: '/create_question.json',
				data: question
			})
			.then(function(response) {
				d.resolve(response);
			},
			function(error) {
				d.reject(error);
			});

			return d.promise;
		}

		this.createAnswersForQuestion = function(answer) {
			var d = $q.defer();

			$http({
				method: 'POST',
				url: 'create_question_answers.json',
				data: answer
			})
			.then(function(response) {
				d.resolve(response);
			},
			function(error) {
				d.reject(error);
			});

			return d.promise;
		}
	});
