require 'httparty'
require 'awesome_print' # puts와 비슷한것 / 프린트를 좀더 예쁘게 해줌
require 'json' # Json 형태의 응답을 파싱하기 위해 추가
require 'nokogiri'
require 'uri'

url = "https://api.telegram.org/bot"
token = "482949183:AAExy4p0vFBTHZa7S6DB1sqyH1sD0zEujzs"

response = HTTParty.get("#{url}#{token}/getUpdates")
hash = JSON.parse(response.body)

# ap hash["result"]
# ap hash["result"][0]
# ap hash["result"][0]["message"]
# ap hash["result"][0]["message"]["from"]
chat_id =  hash["result"][0]["message"]["from"]["id"]


#kospi 지수
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kospi = html.css('#KOSPI_now').text

#로또 API로 로또 번호 가져오기
resp = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
lotto = JSON.parse(resp.body)
number = [lotto["drwtNo1"], lotto["drwtNo2"], lotto["drwtNo3"], lotto["drwtNo4"], lotto["drwtNo5"], lotto["drwtNo6"], lotto["bnusNo"]]
lotto_number = "#{lotto["drwtNo1"]}, #{lotto["drwtNo2"]}, #{lotto["drwtNo3"]}, #{lotto["drwtNo4"]}, #{lotto["drwtNo5"]}, #{lotto["drwtNo6"]}, #{lotto["bnusNo"]}"

message = lotto_number
encoded = URI.encode(message)

while true
  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
  sleep(5) #괄호안에 단위는 초단위이다 / 입력한 초 만큼 재운다.
end
