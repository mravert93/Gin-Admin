angular.module('admin.services', [])
.service('ParseService',
	function($http, $q) {

		var APP_KEY = "KRsv5fl3h1k1qvRvhEQyITCnvIZ7eq8uJDJp9JRC";
		var REST_API_KEY = "SrQRoGsr3Hse9VTXaFnOA6CsopZxx8UjIvlMIFNJ";

		this.createQuestion = function(question) {
			var d = $q.defer();

			// $http({
			// 	method: 'POST',
			// 	url: 'https://api.parse.com/1/classes/Question',
			// 	headers: 
			// 	{
			// 		'X-Parse-Application-Id' : APP_KEY,
			// 		'X-Parse-REST-API-Key' : REST_API_KEY,
			// 		'Content-Type' : 'application/json'
			// 	},
			// 	data: question
			// })
			// .then(function(response) {
			// 	d.resolve(response);
			// },
			// function(error) {
			// 	d.reject(error);
			// });

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
	});