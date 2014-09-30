require 'spec_helper'

feature "user makes a pick", js: true do

	before do
		@user = create(:user)
		@season = Season.create(year: 2014, name: "2014 Season", entry_fee: 50)
    @week = Week.create(season: @season, week_number: 1, start_date: DateTime.new(2014, 8, 5), deadline: DateTime.new(2014, 8, 8), end_date: DateTime.new(2014, 8, 11))
    @webstate = WebState.create(week_id: @week.id)
    @pool_entry1 = PoolEntry.create(user: @user, team_name: "Test Team", paid: true, season_id: @season.id)

    @broncos = NflTeam.create(name: "Denver Broncos", conference: "NFC", division: "West")
    @vikings = NflTeam.create(name: "Minnesota Vikings", conference: "NFC", division: "North")
    @matchup = Matchup.create(week_id: @week.id, home_team: @broncos, away_team: @vikings, game_time: DateTime.new(2014,8,10,11))
	end

	scenario "with an open week", js: true do
		current_user = @user
		login_as current_user, scope: :user
    visit root_path

    click_button("Sign In")

    click_link("Your Picks")

    find(:css, "#select-pick").click

    find(:css, "#select-home-#{@matchup.id}").click

    find(:css, "#save-matchup-#{@matchup.id}").click

    expect(page).to have_content("Denver Broncos")
	end
end