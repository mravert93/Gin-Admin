'use strict';

angular.module('admin', [
	'ngRoute', 
	'admin.controllers', 
	'admin.services',
	'admin.directives' ])
.config(function($routeProvider, $locationProvider) {
	$routeProvider
	.when('/createQuestion',
	{
		controller: 'CreateQuestionController',
		templateUrl: '/templates/create_question.html'
	})
	.when('/',
	{
		controller: 'HomeController',
		templateUrl: '/templates/home.html'
	})
	.otherwise({redirectTo: '/'});

	$locationProvider.html5Mode(true);
});