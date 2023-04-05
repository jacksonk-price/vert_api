class YtDlpDownloader
  require 'timeout'
  attr_accessor :url, :format
  def initialize(url, format)
    @url = url
    @format = format
  end

  def extract_audio
    output, status = Open3.capture2(extract_audio_command)

    { audio: output, status: status }
  end

  def get_video_title
    output, status = Open3.capture2(extract_title_command)

    output = 'untitled' unless status.success?

    { title: output, status: status }
  end

  private

  def extract_audio_command
    "yt-dlp -f 'bestaudio[ext=#{@format}]' --no-continue -o - #{@url}"
  end

  def extract_title_command
    "yt-dlp --get-title #{@url}"
  end
end