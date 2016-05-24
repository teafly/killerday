#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'net/http'
require 'net/https'
require 'open3'
require 'nokogiri'

def getAccessToken

  uri = URI("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=wx60f0179a53a30de9&corpsecret=6jHA-1BeiK-hXMkttZb5Wr604U7G9KFbpdz6LyNhnCcKVUrS5rhafNLxGxf9i7E2")
  req = Net::HTTP::Get.new(uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  res = JSON.parse(https.request(req).body)
  res['access_token']
end

#init token
$token = getAccessToken()

get '/access_token' do

  getAccessToken()
end

get '/wx_callback' do
  
  msg_signature = params['msg_signature']
  timestamp = params['timestamp']
  nonce = params['nonce']
  echostr = params['echostr']
  #puts msg_signature, timestamp, nonce, echostr

  stdin, stdout, stderr, s = Open3.popen3("python", "/home/admin/work/killerday/src/WXVerifyURL.py", 
    msg_signature, timestamp, nonce, echostr)
  ret = stdout.gets.strip
  puts ret
  return ret
end

post '/wx_callback' do
  
  request.body.rewind
  msg_signature = params['msg_signature']
  timestamp = params['timestamp']
  nonce = params['nonce']
  req_data = request.body.read
  #puts msg_signature, timestamp, nonce, req_data

  stdin, stdout, stderr, s = Open3.popen3("python", "/home/admin/work/killerday/src/WXDecryptMsg.py", 
    msg_signature, timestamp, nonce, req_data)
  ret = stdout.readlines.join
  puts ret

  return handleCallback(Nokogiri::XML(ret))
end

get '/msg_test' do

  pushMsg("zhuwang test by server", "ZhuWang")
end


def pushMsg(msg, userIds = nil, partyIds = nil)

  postWX("https://qyapi.weixin.qq.com/cgi-bin/message/send?", {
      touser: userIds,
      toparty: partyIds,
      msgtype: "text",
      agentid: 1,
      text: {
        content: msg
      },
      safe: "0"
  })
  return nil
end

def findUser(userId)

  getWX("https://qyapi.weixin.qq.com/cgi-bin/user/get?userid=" + userId)
end

def handleCallback(xml)

  type = xml.css("MsgType").first.content
  userId = xml.css("FromUserName").first.content

  case type
  when "text"

    return handleText(userId, xml)
  when "event"

    return handleEvent(userId, xml)
  end
end

def handleText(userId, xml)

  user = findUser(userId)
  userName = user['name']
  msg = xml.css('Content').first.content
  pushMsg("#{userName}, 欢迎来到杀人派! 您刚才发的消息是: #{msg}", userId)
end

def handleEvent(userId, xml)

  event = xml.css("Event").first.content

  case event
  when "subscribe"
    return pushMsg("恭喜您订阅成功!", user)
  when "unsubscribe"
    return pushMsg("有空再来玩哦!", user)
  end
end

def postWX(baseUri, body = nil, validToken = true)

  uri = URI(baseUri + "&access_token=" + $token)
  req = Net::HTTP::Post.new(uri)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req.body = body.to_json
  res = JSON.parse(https.request(req).body)
  if validToken && res["errcode"] == 40014
    $token = getAccessToken()
    postWX(baseUri, body, false)
  end
  return res
end

def getWX(baseUri, validToken = true)

  uri = URI(baseUri + "&access_token=" + $token)
  req = Net::HTTP::Get.new(uri)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  res = https.request(req).body
  res = JSON.parse(https.request(req).body)
  if validToken && res["errcode"] == 40014
    $token = getAccessToken()
    getWX(baseUri, false)
  end
  return res
end