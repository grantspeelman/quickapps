module Job

  class CreateDailyWinners

    def run
      # perform work here
      Winner.create_daily_winners
    end

    def on_error(exception)
      # Optionally implement this method to interrogate any exceptions
      # raised inside the job's run method.
      Airbrake.notify_or_ignore(exception,:cgi_data => ENV)
    end

  end

end