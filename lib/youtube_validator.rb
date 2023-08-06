module YoutubeValidator
  def self.valid_url?(url)
    url_regex = /.*(?:https:\/\/www\.youtube\.com\/watch|https:\/\/www\.youtube\.com\/shorts\/).*/
    url_regex.match?(url)
  end
end