angular.module('PoolEntries', ['ngResource', 'RailsApiResource'])

	.factory 'WeekResults', (RailsApiResource) ->
		RailsApiResource('weeks/:parent_id/week_results', 'pool_entries')

	.factory 'NflTeam', (RailsApiResource) ->
		RailsApiResource('nfl_teams', 'nfl_teams')

	.factory 'PickResults', (RailsApiResource) ->
		RailsApiResource('weeks/:parent_id/week_picks', 'picks')

	.controller 'PoolEntriesCtrl', ['$scope', '$location', '$http', '$routeParams', 'NflTeam', 'WeekResults', 'PickResults', 'WebState', 'SeasonWeeks', ($scope, $location, $http, $routeParams, NflTeam, WeekResults, PickResults, WebState, SeasonWeeks) ->

		week_id = parseInt( $routeParams.week_id, 10 )
		$scope.week_id = week_id
		console.log("The passed-in week's ID is: " + $scope.week_id)
		$scope.current_week = {}
		$scope.season_weeks = {}


		$scope.getWebState = () ->
			console.log("(PoolEntriesCtrl.getWebState) Looking up the WebState")
			$scope.web_state = WebState.get(1).then((web_state) ->
				console.log("(PoolEntriesCtrl.getWebState) Have WebState")
				$scope.web_state = web_state
				$scope.current_week = web_state.current_week
				$scope.open_for_picks = web_state.current_week.open_for_picks
				$scope.getNflTeams()
			)

		$scope.getNflTeams = () ->
			console.log("(PoolEntriesCtrl.getNflTeams) Looking up the NflTeams")
			NflTeam.query().then((nfl_teams) ->
				console.log("(PoolEntriesCtrl.getNflTeams) *** Have nfl_teams***")
				$scope.nfl_teams = nfl_teams
				$scope.load_season_weeks()
			)

		$scope.load_season_weeks = () ->
			console.log("(PoolEntriesCtrl.load_season_weeks) Looking up the season_weeks")
			SeasonWeeks.nested_query($scope.web_state.current_week.season.id).then((season_weeks) ->
				console.log("(PoolEntriesCtrl.load_season_weeks) *** Have All Season Weeks ***")
				$scope.season_weeks = season_weeks
				$scope.getWeeklyResults()
			)

		$scope.getWeeklyResults = () ->
			console.log("(PoolEntriesCtrl.getWeeklyResults) Looking up the weekly results for week_id:" + $scope.week_id)
			WeekResults.nested_query($scope.week_id).then(
				(week_results) ->
					console.log("(PoolEntriesCtrl.getWeeklyResults) ...Have Week Results")
					$scope.pool_entries_still_alive = week_results[0]
					$scope.pool_entries_knocked_out_this_week = week_results[1]
					$scope.pool_entries_knocked_out_previously = week_results[2]
					$scope.unmatched_pool_entries = week_results[3]
				(json_error_data) ->
					console.log("(PoolEntriesCtrl.getWeeklyResults) Error getting Week Results")
					$scope.error_message = json_error_data.data[0].error
			)

		$scope.still_alive_count = () ->
			if $scope.pool_entries_still_alive
				$scope.pool_entries_still_alive.length
			else
				"0"

		$scope.knocked_out_this_week_count = () ->
			if $scope.pool_entries_knocked_out_this_week
				$scope.pool_entries_knocked_out_this_week.length
			else
				"0"

		$scope.knocked_out_previously_count = () ->
			if $scope.pool_entries_knocked_out_previously
				$scope.pool_entries_knocked_out_previously.length
			else
				"0"

		$scope.getWebState()


		$scope.results_header = ->
			console.log("(matchup_header) week_id:" + parseInt($scope.week_id) + " current_week.id:" + $scope.current_week.id)
			if parseInt($scope.week_id) == $scope.current_week.id
				"Live Results from This Round (Week " + $scope.current_week.week_number + ")"
			else
				"Results From a Previous Week"

	]