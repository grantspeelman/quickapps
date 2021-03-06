require 'uservoice-ruby'

class SendFeedbackToUservoice
  def self.perform(feedback)
    new.perform(feedback)
  end

  def perform(feedback)
    send_options = {:email => feedback.user_account_email,
                    :subject => "[#{feedback.app_name}] #{feedback.subject}",
                    :message => feedback.message,
                    :name => feedback.user_account_real_name || CGI::unescape(feedback.user_account_name.to_s).gsub(/[^a-zA-Z0-9\s]/, '')}
    if feedback.support_type == 'suggestion'
      send_suggestion(send_options)
    else
      send_support(send_options)
    end
  end

  def send_suggestion(options = {})
    client = UserVoice::Client.new(subdomain_name, api_key, api_secret)
    forum = client.get('/api/v1/forums.json')['forums'].first
    forum_id = forum['id']
    client.login_as(options[:email]) do |access_token|
      access_token.post("/api/v1/forums/#{forum_id}/suggestions.json", {
        :suggestion => {
          :title => options[:subject],
          :text => options[:message],
          :votes => 0
        }
      })
    end
  end

  def send_support(options = {})
    client = UserVoice::Client.new(subdomain_name, api_key, api_secret)
    client.post('/api/v1/tickets.json', {
      :email => options[:email],
      :name => options[:name],
      :ticket => {
        :subject => options[:subject],
        :message => options[:message]
      }
    })
  end

  def subdomain_name
    ENV['UV_SUBDOMAIN_NAME']
  end

  def api_key
    ENV['UV_API_KEY']
  end

  def api_secret
    ENV['UV_API_SECRET']
  end
end
