module YoutubeValidator
  def self.valid_url?(url)
    url_regex = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
    url_regex.match?(url)
  end
end