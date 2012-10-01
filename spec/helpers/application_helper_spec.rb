require 'spec_helper'

describe ApplicationHelper do

  context "shinka_ad" do

    it "must load a add from shinka" do
      body = "{\"ads\":\n {\n  \"version\": 1,\n  \"count\": 1,\n  \"ad\": [\n        {\n         \"adunitid\":290386,\n         \"adid\":545949,\n         \"type\":\"image\",\n         \"html\":\"<a href='http://ox-d.shinka.sh/ma/1.0/rc?ai=00b04200-57ca-0db6-12f9-33021e699eba&ts=1fHNpZD01OTI4MXxhdWlkPTI5MDM4NnxhaWQ9NTQ1OTQ5fHB1Yj03Mzg0MnxsaWQ9MzEzMTg0fHQ9OXxyaWQ9YmUzYTI2NjEtMjMyMi00YzU2LTk4ZTYtYTU3MDEzODA5NzU5fG9pZD04ODI2N3xibT1CVVlJTkcuSE9VU0V8cGM9WkFSfHA9MHxhYz1aQVJ8cG09UFJJQ0lORy5DUE18cnQ9MTM0OTA4MzU4Nnxwcj0wfGFkdj02NjMwOA' target='_blank'><img src='http://ox-i.shinka.sh/bba/bbaf2d46-b832-428c-9e22-14accb9dbd89/f43/f43d9f51fe75437e17345d77154bbc43.png' height='50' width='300' border='0' alt='Advertise on the Shinka network here! '></a><div id='beacon_86153914' style='position: absolute; left: 0px; top: 0px; visibility: hidden;'><img src='http://ox-d.shinka.sh/ma/1.0/ri?ai=00b04200-57ca-0db6-12f9-33021e699eba&ts=1fHNpZD01OTI4MXxhdWlkPTI5MDM4NnxhaWQ9NTQ1OTQ5fHB1Yj03Mzg0MnxsaWQ9MzEzMTg0fHQ9OXxyaWQ9YmUzYTI2NjEtMjMyMi00YzU2LTk4ZTYtYTU3MDEzODA5NzU5fG9pZD04ODI2N3xibT1CVVlJTkcuSE9VU0V8cGM9WkFSfHA9MHxhYz1aQVJ8cG09UFJJQ0lORy5DUE18cnQ9MTM0OTA4MzU4Nnxwcj0wfGFkdj02NjMwOA&cb=86153914'/></div>\\n\",\n         \"is_fallback\":0,\n         \"creative\":[\n           {\n             \"width\":\"300\",\n             \"height\":\"50\",\n             \"alt\":\"Advertise on the Shinka network here! \",\n             \"target\":\"_blank\",\n             \"mime\":\"image/png\",\n             \"media\": \"http://ox-i.shinka.sh/bba/bbaf2d46-b832-428c-9e22-14accb9dbd89/f43/f43d9f51fe75437e17345d77154bbc43.png\",\n             \"tracking\":{\n               \"impression\":\"http://ox-d.shinka.sh/ma/1.0/ri?ai=00b04200-57ca-0db6-12f9-33021e699eba&ts=1fHNpZD01OTI4MXxhdWlkPTI5MDM4NnxhaWQ9NTQ1OTQ5fHB1Yj03Mzg0MnxsaWQ9MzEzMTg0fHQ9OXxyaWQ9YmUzYTI2NjEtMjMyMi00YzU2LTk4ZTYtYTU3MDEzODA5NzU5fG9pZD04ODI2N3xibT1CVVlJTkcuSE9VU0V8cGM9WkFSfHA9MHxhYz1aQVJ8cG09UFJJQ0lORy5DUE18cnQ9MTM0OTA4MzU4Nnxwcj0wfGFkdj02NjMwOA&cb=86153914\",\n               \"inview\":\"http://ox-d.shinka.sh/ma/1.0/rvi?ai=00b04200-57ca-0db6-12f9-33021e699eba&ts=1fHNpZD01OTI4MXxhdWlkPTI5MDM4NnxhaWQ9NTQ1OTQ5fHB1Yj03Mzg0MnxsaWQ9MzEzMTg0fHQ9OXxyaWQ9YmUzYTI2NjEtMjMyMi00YzU2LTk4ZTYtYTU3MDEzODA5NzU5fG9pZD04ODI2N3xibT1CVVlJTkcuSE9VU0V8cGM9WkFSfHA9MHxhYz1aQVJ8cG09UFJJQ0lORy5DUE18cnQ9MTM0OTA4MzU4Nnxwcj0wfGFkdj02NjMwOA&cb=86153914\",\n               \"click\":\"http://ox-d.shinka.sh/ma/1.0/rc?ai=00b04200-57ca-0db6-12f9-33021e699eba&ts=1fHNpZD01OTI4MXxhdWlkPTI5MDM4NnxhaWQ9NTQ1OTQ5fHB1Yj03Mzg0MnxsaWQ9MzEzMTg0fHQ9OXxyaWQ9YmUzYTI2NjEtMjMyMi00YzU2LTk4ZTYtYTU3MDEzODA5NzU5fG9pZD04ODI2N3xibT1CVVlJTkcuSE9VU0V8cGM9WkFSfHA9MHxhYz1aQVJ8cG09UFJJQ0lORy5DUE18cnQ9MTM0OTA4MzU4Nnxwcj0wfGFkdj02NjMwOA\"\n             }\n           }\n         ]\n        }\n  ]\n }\n}\n"
      stub_request(:get, "http://ox-d.shinka.sh/ma/1.0/arj?auid=290386&c.age=&c.country=&c.gender=").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => body, :headers => {})
      helper.stub(:current_user_request_info).and_return(UserRequestInfo.new)
      helper.shinka_ad.should include("onclick='window.open(this.href); return false;'")
    end

    it "must load blank ad if shinka code throws exception" do
      helper.stub(:current_user_request_info).and_raise
      helper.shinka_ad.should include("")
    end

  end

end