#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'net/http'
require 'net/https'

def getAccessToken

  uri = URI("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=wx60f0179a53a30de9&corpsecret=6jHA-1BeiK-hXMkttZb5Wr604U7G9KFbpdz6LyNhnCcKVUrS5rhafNLxGxf9i7E2")
  req = Net::HTTP::Get.new(uri)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  res = JSON.parse(https.request(req).body)
  res['access_token']
end

#init token
$token = getAccessToken()

get '/access_token' do

  getAccessToken()
end

get '/msg' do

  pushMsg("zhuwang test by server", "zhuwang")
end


def pushMsg(msg, userIds = nil, partyIds = nil)

  post_wx("https://qyapi.weixin.qq.com/cgi-bin/message/send?", {
      touser: userIds,
      toparty: partyIds,
      msgtype: "text",
      agentid: 1,
      text: {
        content: msg
      },
      safe: "0"
  })
end

def post_wx(baseUri, body = nil, validToken = true)

  uri = URI(baseUri + "&access_token=" + $token)
  req = Net::HTTP::Post.new(uri)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req.body = body.to_json
  res = JSON.parse(https.request(req).body)
  if validToken && res["errcode"] == 40014
    $token = getAccessToken()
    post_wx(baseUri, body, false)
  end
  return res
end

def get_wx(baseUri, validToken = true)

  uri = URI(baseUri + "&access_token=" + $token)
  req = Net::HTTP::Get.new(uri)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  res = https.request(req).body
  res = JSON.parse(https.request(req).body)
  if validToken && res["errcode"] == 40014
    $token = getAccessToken()
    get_wx(baseUri, false)
  end
  return res
end