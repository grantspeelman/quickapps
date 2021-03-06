require 'view_spec_helper'

describe 'redeem_winnings/index.html.erb' do
  before(:each) do
    @current_user_account = stub_model(UserAccount, id: 50, registered_on_mxit_money?: false)
    view.stub(:current_user_account).and_return(@current_user_account)
    view.stub(:menu_item)
  end

  it 'should have a airtime vouchers link on menu' do
    view.should_receive(:menu_item).with(anything,airtime_vouchers_path,id: 'airtime_vouchers')
    render
  end

  context 'mxit money' do
    before :each do
      @current_user_account.stub(:registered_on_mxit_money?).and_return(true)
    end

    it 'must have equal mxit available to prize points' do
      @current_user_account.prize_points = 1
      render
      rendered.should have_content("R0.0#{@current_user_account.prize_points} mxit money")
    end

    it 'must have a mxit money link' do
      @current_user_account.prize_points = 51
      render
      rendered.should have_link('mxit_money', href: new_redeem_winning_path(:prize_type => 'mxit_money',
                                                                            :prize_amount => 51))
    end

    it 'wont have a mxit_money link if not enough prize points' do
      @current_user_account.prize_points = 0
      render
      rendered.should_not have_link('mxit_money')
    end

    it 'wont have a mxit_money link not registered on mxit money' do
      @current_user_account.prize_points = 100
      @current_user_account.should_receive(:registered_on_mxit_money?).and_return(false)
      render
      rendered.should_not have_link('mxit_money')
    end

    it 'wont have a mxit_money link if disabled in settings' do
      @current_user_account.prize_points = 100
      Settings.should_receive(:mxit_money_disabled_until).and_return(2.hours.from_now)
      render
      rendered.should_not have_link('mxit_money')
    end
  end

  context 'vodago airtime' do
    it 'must have R% airtime and link' do
      @current_user_account.prize_points = 500
      render
      rendered.should have_content('R5 vodago')
      rendered.should have_link('vodago_airtime',
                                href: new_redeem_winning_path(:prize_type => 'vodago_airtime',
                                                              :prize_amount => 500))
    end

    it 'must have R10 airtime and link' do
      @current_user_account.prize_points = 1000
      render
      rendered.should have_content('R10 vodago')
      rendered.should have_link('vodago_airtime',
                               href: new_redeem_winning_path(:prize_type => 'vodago_airtime',
                                                             :prize_amount => 1000))
    end

    it 'must have R12 airtime and link' do
      @current_user_account.prize_points = 1200
      render
      rendered.should have_content('R12 vodago')
      rendered.should have_link('vodago_airtime',
                               href: new_redeem_winning_path(:prize_type => 'vodago_airtime',
                                                             :prize_amount => 1200))
    end

    it 'must have a text if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should have_content('R5 vodago')
    end

    it 'wont have a link if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should_not have_link('vodago_airtime')
    end
  end

  context 'mtn airtime' do
    it 'must have R5 airtime and link' do
      @current_user_account.prize_points = 500
      render
      rendered.should have_content('R5 mtn')
      rendered.should have_link('mtn_airtime',
                                href: new_redeem_winning_path(:prize_type => 'mtn_airtime',
                                                              :prize_amount => 500))
    end

    it 'must have R10 airtime and link' do
      @current_user_account.prize_points = 1000
      render
      rendered.should have_content('R10 mtn')
      rendered.should have_link('mtn_airtime',
                                href: new_redeem_winning_path(:prize_type => 'mtn_airtime',
                                                              :prize_amount => 1000))
    end

    it 'must have R15 airtime and link' do
      @current_user_account.prize_points = 1500
      render
      rendered.should have_content('R15 mtn')
      rendered.should have_link('mtn_airtime',
                                href: new_redeem_winning_path(:prize_type => 'mtn_airtime',
                                                              :prize_amount => 1500))
    end

    it 'must have a text if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should have_content('R5 mtn')
    end

    it 'wont have a link if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should_not have_link('mtn_airtime')
    end
  end

  context 'cell_c airtime' do
    it 'must have R5 airtime and link' do
      @current_user_account.prize_points = 500
      render
      rendered.should have_content('R5 cell c')
      rendered.should have_link('cell_c_airtime',
                                href: new_redeem_winning_path(:prize_type => 'cell_c_airtime',
                                                              :prize_amount => 500))
    end

    it 'must have R10 airtime and link' do
      @current_user_account.prize_points = 1000
      render
      rendered.should have_content('R10 cell c')
      rendered.should have_link('cell_c_airtime',
                                href: new_redeem_winning_path(:prize_type => 'cell_c_airtime',
                                                              :prize_amount => 1000))
    end

    it 'must have R25 airtime and link' do
      @current_user_account.prize_points = 2500
      render
      rendered.should have_content('R25 cell c')
      rendered.should have_link('cell_c_airtime',
                                href: new_redeem_winning_path(:prize_type => 'cell_c_airtime',
                                                              :prize_amount => 2500))
    end

    it 'must have a text if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should have_content('R5 cell c')
    end

    it 'wont have a link if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should_not have_link('cell_c_airtime')
    end
  end

  context 'virgin airtime' do
    it 'must have R10 airtime and link' do
      @current_user_account.prize_points = 1000
      render
      rendered.should have_content('R10 virgin')
      rendered.should have_link('virgin_airtime',
                                href: new_redeem_winning_path(:prize_type => 'virgin_airtime',
                                                              :prize_amount => 1000))
    end

    it 'must have R15 airtime and link' do
      @current_user_account.prize_points = 1500
      render
      rendered.should have_content('R15 virgin')
      rendered.should have_link('virgin_airtime',
                                href: new_redeem_winning_path(:prize_type => 'virgin_airtime',
                                                              :prize_amount => 1500))
    end

    it 'must have R35 airtime and link' do
      @current_user_account.prize_points = 3500
      render
      rendered.should have_content('R35 virgin')
      rendered.should have_link('virgin_airtime',
                                href: new_redeem_winning_path(:prize_type => 'virgin_airtime',
                                                              :prize_amount => 3500))
    end

    it 'must have a text if not enough prize points' do
      @current_user_account.prize_points = 999
      render
      rendered.should have_content('R10 virgin')
    end

    it 'wont have a link if not enough prize points' do
      @current_user_account.prize_points = 999
      render
      rendered.should_not have_link('virgin_airtime')
    end
  end

  context 'heita airtime' do
    it 'must have R5 airtime and link' do
      @current_user_account.prize_points = 500
      render
      rendered.should have_content('R5 heita')
      rendered.should have_link('heita_airtime',
                                href: new_redeem_winning_path(:prize_type => 'heita_airtime',
                                                              :prize_amount => 500))
    end

    it 'must have R10 airtime and link' do
      @current_user_account.prize_points = 1000
      render
      rendered.should have_content('R10 heita')
      rendered.should have_link('heita_airtime',
                                href: new_redeem_winning_path(:prize_type => 'heita_airtime',
                                                              :prize_amount => 1000))
    end

    it 'must have R20 airtime and link' do
      @current_user_account.prize_points = 2000
      render
      rendered.should have_content('R20 heita')
      rendered.should have_link('heita_airtime',
                                href: new_redeem_winning_path(:prize_type => 'heita_airtime',
                                                              :prize_amount => 2000))
    end

    it 'must have a text if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should have_content('R5 heita')
    end

    it 'wont have a link if not enough prize points' do
      @current_user_account.prize_points = 499
      render
      rendered.should_not have_link('heita_airtime')
    end
  end
end
