require 'spec_helper'

describe User do

  it "must have a provider" do
    User.new.should have(1).errors_on(:provider)
    User.new(provider: 'xx').should have(0).errors_on(:provider)
  end

  it "must have a uid" do
    User.new.should have(1).errors_on(:uid)
    User.new(uid: 'xx').should have(0).errors_on(:uid)
  end

  it "must have a unique uid per provider" do
    create(:user, uid: "xx", provider: "yy")
    User.new(uid: 'xx', provider: "yy").should have(1).errors_on(:uid)
    User.new(uid: 'xx', provider: "zz").should have(0).errors_on(:uid)
  end

  it "must return the amount of games" do
    user = create(:user)
    user.game_count.should == 0
    create(:game, user: user)
    user.game_count.should == 1
    create_list(:game,5, user: user)
    user.game_count.should == 6
  end

  context "calculate_games_won_this_week" do

    it "must use only won games" do
      user = create(:user)
      create_list(:won_game,2, user: user)
      create(:lost_game, user: user)
      create(:game, user: user)
      user.calculate_games_won_this_week.should == 2
    end


    it "must use games only from this week" do
      user = create(:user)
      create_list(:won_game,2,user: user)
      Timecop.freeze(1.week.ago - 1.day) do
        create_list(:won_game,2,user: user)
      end
      user.calculate_games_won_this_week.should == 2
    end

  end

  context "calculate_games_won_this_month" do

    it "must use only won games" do
      user = create(:user)
      create_list(:won_game,2, user: user)
      create(:lost_game, user: user)
      create(:game, user: user)
      user.calculate_games_won_this_month.should == 2
    end


    it "must use games only from this month" do
      user = create(:user)
      create_list(:won_game,2,user: user)
      Timecop.freeze(1.month.ago - 1.day) do
        create_list(:won_game,2,user: user)
      end
      user.calculate_games_won_this_month.should == 2
    end

  end

  context "calculate_weekly_precision" do

    it "must use the attempts left per game" do
      user = create(:user)
      create_list(:won_game,9, word: "test", choices: "tes", user: user)
      create(:won_game, word: "test", choices: "ters", user: user)
      user.calculate_weekly_precision.should == 99
    end

    it "must use only completed games" do
      user = create(:user)
      create_list(:won_game,10, word: "test", choices: "tes", user: user)
      create(:game, word: "test", choices: "ter", user: user)
      user.calculate_weekly_precision.should == 100
    end

    it "must use games only from this week" do
      user = create(:user)
      create_list(:won_game,10, word: "test", choices: "tes", user: user)
      Timecop.freeze(1.week.ago - 1.day) do
        create(:won_game, word: "test", choices: "ters", user: user)
      end
      user.calculate_weekly_precision.should == 100
    end

    it "must return 0 if less than 10 games played" do
      user = create(:user)
      create_list(:won_game,9, word: "test", choices: "tes", user: user)
      user.calculate_weekly_precision.should == 0
    end

  end

  context "calculate_monthly_precision" do

    it "must use the attempts left per game" do
      user = create(:user)
      create_list(:won_game,39, word: "test", choices: "tes", user: user)
      create(:won_game, word: "test", choices: "ters", user: user)
      user.calculate_monthly_precision.should == 99
    end

    it "must use only completed games" do
      user = create(:user)
      create_list(:won_game,40, word: "test", choices: "tes", user: user)
      create(:game, word: "test", choices: "ter", user: user)
      user.calculate_monthly_precision.should == 100
    end

    it "must use games only from this month" do
      user = create(:user)
      create_list(:won_game,40, word: "test", choices: "tes", user: user)
      Timecop.freeze(1.month.ago - 1.day) do
        create(:won_game, word: "test", choices: "ters", user: user)
      end
      user.calculate_monthly_precision.should == 100
    end

    it "must return 0 if less than 40 games played" do
      user = create(:user)
      create_list(:won_game,39, word: "test", choices: "tes", user: user)
      user.calculate_monthly_precision.should == 0
    end

  end

  context "calculate_weekly_rating" do

    it "must use 20 games in the last week" do
      user = create(:user)
      create_list(:won_game, 21,  score: 1, user: user)
      user.calculate_weekly_rating.should == 20
    end

    it "must use games only from this week" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.week.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_weekly_rating.should == 20
    end

    it "must use top scoring games in the last week" do
      user = create(:user)
      create_list(:won_game, 20,  score: 1, user: user)
      create(:won_game, score: 21, user: user)
      user.calculate_weekly_rating.should == 40
    end

  end

  context "calculate_monthly_rating" do

    it "must use 80 games in the last month" do
      user = create(:user)
      create_list(:won_game, 81,  score: 1, user: user)
      user.calculate_monthly_rating.should == 80
    end

    it "must use games only from this month" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.month.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_monthly_rating.should == 20
    end

    it "must use top scoring games in the last week" do
      user = create(:user)
      create_list(:won_game, 80,  score: 1, user: user)
      create(:won_game, score: 21, user: user)
      user.calculate_monthly_rating.should == 100
    end

  end

  context "calculate_yearly_rating" do

    it "must use 160 games in the last month" do
      user = create(:user)
      create_list(:won_game, 161,  score: 1, user: user)
      user.calculate_yearly_rating.should == 160
    end

    it "must use games only from this year" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.year.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_yearly_rating.should == 20
    end

    it "must use top scoring games in the last year" do
      user = create(:user)
      create_list(:won_game, 160,  score: 1, user: user)
      create(:won_game, score: 41, user: user)
      user.calculate_yearly_rating.should == 200
    end

  end

  context "calculate_score" do

    it "must update the ratings" do
      user = stub_model(User)
      user.stub(:calculate_weekly_rating).and_return(20)
      user.stub(:calculate_monthly_rating).and_return(80)
      user.stub(:calculate_weekly_precision).and_return(100)
      user.stub(:calculate_monthly_precision).and_return(90)
      user.stub(:calculate_games_won_this_week).and_return(200)
      user.stub(:calculate_games_won_this_month).and_return(210)
      user.update_ratings
      user.weekly_rating.should == 20
      user.monthly_rating.should == 80
      user.weekly_precision.should == 100
      user.monthly_precision.should == 90
      user.games_won_this_week.should == 200
      user.games_won_this_month.should == 210
    end

  end

  context "rank" do

    it "should return correct rankings" do
      user1, user3, user2 = create(:user, weekly_rating: 20), create(:user, weekly_rating: 40), create(:user, weekly_rating: 30)
      user1.rank(:weekly_rating).should == 3
      user3.rank(:weekly_rating).should == 1
      user2.rank(:weekly_rating).should == 2
    end

  end

  context "find_or_create_from_auth_hash" do

    it "must create a new user if no uid and provider match exists" do
      expect {
        user = User.find_or_create_from_auth_hash(uid: "u", provider: "p", info: {name: "Grant"})
        user.uid.should == 'u'
        user.provider.should == 'p'
        user.name.should == 'Grant'
      }.to change(User, :count).by(1)
    end

    it "must return existing user if uid and provider match exists" do
      user_id = create(:user, uid: "u1", provider: "p", name: "Pawel").id
      expect {
        user = User.find_or_create_from_auth_hash(uid: "u1", provider: "p", info: {name: "Grant"})
        user.uid.should == 'u1'
        user.provider.should == 'p'
        user.id == user_id
      }.to change(User, :count).by(0)
    end

    it "must return nil if no uid" do
      User.find_or_create_from_auth_hash(uid: "", provider: "p", info: {name: "Grant"}).should be_nil
    end

    it "must return nil if no provider" do
      User.find_or_create_from_auth_hash(uid: "u", provider: "", info: {name: "Grant"}).should be_nil
    end

  end

end
