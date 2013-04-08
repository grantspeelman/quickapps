require 'spec_helper'

shared_examples "a winner viewer" do

  it "must show the daily and weekly winners" do
    users = create_list(:user,5, :daily_precision => 100, :daily_streak => 100, :daily_rating => 100)
    random_users = create_list(:user,5, :daily_wins => Winner.daily_random_games_required)
    Timecop.freeze(Date.yesterday) do
      Jobs::CreateDailyWinners.execute
    end
    visit '/'
    click_link('rank')
    click_link('winners')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('precision')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('streak')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('random')
    random_users.each do |winner|
      page.should have_content(winner.name)
    end

  end

  it "must show the weekly winners" do
    users = create_list(:user,5, :weekly_precision => 100, :weekly_streak => 100, :weekly_rating => 100)
    random_users = create_list(:user,5, :weekly_wins => Winner.weekly_random_games_required)
    Timecop.freeze(Date.current.beginning_of_week.yesterday) do
      Jobs::CreateWeeklyWinners.execute
    end
    visit '/'
    click_link('rank')
    click_link('winners')
    click_link('weekly')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('precision')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('streak')
    users.each do |winner|
      page.should have_content(winner.name)
    end
    click_link('random')
    random_users.each do |winner|
      page.should have_content(winner.name)
    end
  end

end

describe 'winners',  :redis => true do

  before :each do
    stub_google_tracking # stub google tracking
    stub_mxit_oauth
  end

  context "as mxit user", :shinka_vcr => true do

    before :each do
      @current_user = create(:user, uid: 'm2604100', provider: 'mxit')
      set_mxit_headers('m2604100') # set mxit user
      stub_shinka_request # stub shinka request
      MxitApiWrapper.any_instance.stub(:send_message).and_return(true)
    end

    it "must show the winners if user mxit input is winner" do
      add_headers('X_MXIT_USER_INPUT' => 'winners')
      visit '/'
      page.current_path.should == winners_path
    end

    it_behaves_like "a winner viewer"

  end

  context "as mobile user", :smaato_vcr => true, :js => true do

    before :each do
      @current_user = create(:user, uid: '1234567', provider: 'facebook')
    end

    it_behaves_like "a winner viewer"

  end


end