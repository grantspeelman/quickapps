module ApplicationHelper

  def shinka_ad
    result = ""
    begin
      ads = ActiveSupport::JSON.decode(open("http://ox-d.shinka.sh/ma/1.0/arj?auid=290386&c.age=#{current_user_request_info.age}&c.gender=#{current_user_request_info.gender}&c.country=#{current_user_request_info.country}").read)
      ad = ads['ads']["ad"].sample
      result = ad["html"].html_safe
      impression = ad["creative"].first["tracking"]["impression"]
      alt = ad["creative"].first["alt"]
      click = ad["creative"].first["tracking"]["click"]
      return "" if alt.include?("http")
      "<img href=#{impression} alt=\"\" height=\"1\" width=\"1\"/><a href=#{click} onclick='window.open(this.href); return false;' >#{alt}</a>".html_safe
    rescue Exception => e
      Rails.logger.error e.message
      return result
    end
  end

end
