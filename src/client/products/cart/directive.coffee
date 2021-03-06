angular.module('coffeeshop').directive "productCart", ()->
	restrict: "A"
	scope: {
		product: "="
		params: "@"
	}
	templateUrl: "products/cart/widget"
	replace: true
	transclude: false
	link: (scope, element, attrs, controller)->
		console.log "productCart Directive Link Function!"
		console.log scope, element, attrs, controller
	controller: ($scope)->
		console.log "productCart Directive ctrl"
		#Default config options
		defaults = {
			"inline": false
		}

		#Setup for the override
		params = {}
		if $scope.params
			params = JSON.parse($scope.params)

		#Override defaults
		for opt, val of params
			defaults[opt] = val
		$scope.config = defaults
