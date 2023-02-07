module YoutubeDlConfig
  extend ActiveSupport::Concern
  def build_command(conversion_id, url)
    "youtube-dl -o \"/home/jackson/gitrepos/vert_api/public/user_downloads/#{conversion_id}.%(ext)s\" --extract-audio --audio-format mp3 #{url}"
  end

end