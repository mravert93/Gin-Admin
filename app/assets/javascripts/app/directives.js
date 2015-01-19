angular.module('admin.directives', [])
.directive('panel',
	function()
	{
		return {
			templateUrl: '/templates/panel.html',
			constroller: function($scope) {
				console.log("Panel directive");
			}
		}
	});