username = "hexi98" # GitHub 用户名
new_token = "d975e8d37e42498db34891d2366cf231db37b939"  # GitHub Token
repo_name = "rys-comments" # 存放 issues
kind = "Gitalk" # "Gitalk" or "gitment"
urls = ["https://github.com/hexi98/rys-comments.git"]

require 'open-uri'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'

conn = Faraday.new(:url => "https://api.github.com/repos/#{username}/#{repo_name}/issues") do |conn|
  conn.basic_auth(username, token)
  conn.adapter  Faraday.default_adapter
end

urls.each_with_index do |url, index|
  title = open(url).read.scan(/<title>(.*?)<\/title>/).first.first.force_encoding('UTF-8')
  response = conn.post do |req|
    req.body = { body: url, labels: [kind, url], title: title }.to_json
  end
  puts response.body
  sleep 15 if index % 20 == 0
end