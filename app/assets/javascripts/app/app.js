'use strict';

angular.module('admin', [
	'ngRoute', 
	'ngCookies',
	'admin.controllers', 
	'admin.services',
	'admin.directives' ])
.config(function($routeProvider, $locationProvider) {
	$routeProvider
	.when('/login',
	{
		controller: 'LoginController',
		templateUrl: '/templates/login.html'
	})
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
})
.run(function($rootScope, $location, $cookieStore) {

	// register listener to watch route changes
    $rootScope.$on( "$routeChangeStart", function(event, next, current) {
      if ( $rootScope.loggedUser == null && $cookieStore.get("sessionToken") == null) {
        // no logged user, we should be going to #login
        if ( next.templateUrl == "partials/login.html" ) {
          // already going to #login, no redirect needed
        } else {
          // not going to #login, we should redirect now
          $location.path( "/login" );
        }
      }         
    });
});