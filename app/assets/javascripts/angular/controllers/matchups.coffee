angular.module('Matchups', ['ngResource', 'RailsApiResource'])

	.factory 'Matchup', (RailsApiResource) ->
		RailsApiResource('weeks/:parent_id/matchups', 'matchups')

	.factory 'NflTeam', (RailsApiResource) ->
    RailsApiResource('nfl_teams', 'nfl_teams')

	.controller 'MatchupsCtrl', ['$scope', '$location', '$http', '$routeParams', 'Matchup', 'NflTeam', ($scope, $location, $http, $routeParams, Matchup, NflTeam) ->
		$scope.controller = 'MatchupsCtrl'
		console.log("MatchupsCtrl")
		console.log("$location:" + $location)

		$scope.matchups = []
		NflTeam.query().then((nfl_teams) ->
      $scope.nfl_teams = nfl_teams
      console.log("*** Have nfl_teams***")
    )

		$scope.week_id = week_id = $routeParams.week_id
		$scope.matchup_id = matchup_id = $routeParams.matchup_id

    ## Controller code for loading matchup 

		if matchup_id? and matchup_id == "new"
      console.log("...Creating a new team")
      $scope.matchup = new Matchup({})
    else if matchup_id?
      console.log("...Looking up a single team")
      $scope.matchup = Matchup.get(matchup_id, week_id).then((matchup) ->
        $scope.matchup = matchup
        console.log("Returned matchup" + matchup)
      )
    else
		  Matchup.nested_query(week_id).then((matchups) ->
        $scope.matchups = matchups
        console.log("*** Have matchups***")
      )
      ## Selecting Matchups
    $scope.tieSelected = tie_selected = false
    $scope.homeSelected = home_selected = false
    $scope.awaySelected = away_selected = false

    $scope.outcomeCollection = [tie_selected, home_selected, away_selected]

    $scope.selectedIndex = -1

    $scope.selectOutcome = (outcome) ->
      $scope.selectedOutcome = true

		$scope.selectMatchup = (matchup) ->
			$scope.selectedMatchup = matchup

		$scope.isSelected = (outcome) ->
			$scope.outcome == true

    $scope.selectButton = (outcome) ->
      if $scope.outcome == true
        $scope.


    ## Save an edited matchup
		$scope.save = (matchup) ->
        console.log("MatchupsCtrl.save...")
        if matchup.id?
          console.log("Saving matchup id " + matchup.id)
          matchup.home_team_id = $scope.selected_home_team.id
          matchup.away_team_id = $scope.selected_away_team.id
          Matchup.save(matchup, matchup.week_id).then((matchup) ->
            $scope.matchup = matchup
          )
        else
          console.log("First-time save need POST new id")
          Matchup.create(matchup).then((matchup) ->
            $scope.matchup = matchup
          )
        $location.path ('/weeks/:week_id/matchups')
	]