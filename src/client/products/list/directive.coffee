angular.module('coffeeshop').directive "productList", ()->
		restrict: "A"
		scope: {
			products: "="
			initialSelection: "="
			onSelectionChange: "&"
			params: "@"
		}
		templateUrl: "products/list/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
#			scope.$watch "products", (update, old)->
#				console.log "Products updated!", old, update

			console.log "productList Directive - Link Function!"
			console.log( scope, element, attrs, controller )
		controller: ($scope, storage)->
			console.log "productList Directive - Controller Function"

			#Default config options
			defaults = {
				"status" : "active"
				"image": "thumbnail" #false, thumbnail, medium, large, full - options for images
				"description": true
				"price": true
				"qty": true
				"addToCart": true
				"search": true
				"multiselect": false
				"title": false
				"compact": false
				"placeholder":
					"thumbnail": "/placeholder/thumbnail"
					"medium"   : "/placeholder/medium"
					"large"    : "/placeholder/large"
					"fullsize" : "/placeholder/fullsize"
			}

			#Setup for the override
			params = {}
			if $scope.params
				params = JSON.parse($scope.params)

			#Override defaults
			for opt, val of params
				defaults[opt] = val
			$scope.config = defaults

			#After I changed the way config is handled, this may no longer be necessary.
			$scope.type = $scope.status

			#The selected entities will be added here.
			#In multiselect mode, this array may contain more than one entity.
			#If not multiselect, this will contain at most one entity, duh!
			$scope.selection = []

			#Add initial selection to the current selection.
			if $scope.initialSelection
				for selected in $scope.initialSelection
					$scope.selection.push selected

			#Nothing like a description that just won't shutup! Nowhamsayin?
			$scope.trimIt = (str, length = 100)->
				str.substring 0, length

			$scope.getImage = (product)->
				if $scope.config.image
					src = $scope.config.placeholder[$scope.config.image]
					if product.pictures.length > 0
						src = product.pictures[0][$scope.config.image]
					src

			#This is what will be triggered when someone clicks on an entity in the list.
			#In multiselect mode, we check to see if entity is in the selection already. If so, it is removed.
			##If not, we add it. Then pass the array to the callback.
			#In single select mode, we set selection[0] to the entity, not caring if it is already selected.
			##Then we pass just the entity to the callback, because we are nice like that.
			$scope.makeSelection = (entity)->
				console.log "productList Directive - makeSelection() Called!", entity, $scope.selection

				if $scope.config.multiselect
					console.log "productList Directive - we are a multiselect!"
					if entity not in $scope.selection
						$scope.selection.push entity
						console.log "productList Directive - adding to selection!"
					else
						i = $scope.selection.indexOf entity
						$scope.selection.splice(i, 1)
						console.log "productList Directive - removing from selection!"
					toReturn = $scope.selection
				else
					$scope.selection[0] = entity
					console.log "productList Directive - we are a single select..."
					toReturn = entity

				console.log "productList Directive - we will be returning: ", toReturn

				#Is it required to check if this is a function? I think angular might take care of this for us.
				#because I think it wraps it in a function anways resulting in a noop if not specified.
				if typeof $scope.onSelectionChange is "function"
					console.log "productList Directive - Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelectionChange({"selection":toReturn})
