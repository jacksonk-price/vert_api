class Download < ApplicationRecord
  require 'yt_dlp_downloader'
  require 'ffmpeg_converter'

  def convert_url
    # youtube provides m4a audio format.
    # convert to m4a format first
    ytdlp = YtDlpDownloader.new(video_url, 'm4a')
    yt_dlp_audio = ytdlp.extract_audio
    yt_dlp_title = ytdlp.get_video_title
      # then convert to wav
    wav_result = FfmpegConverter.new(yt_dlp_audio[:audio]).convert_to_wav
    # encode wav binary to base64
    encoded_wav = Base64.encode64(wav_result[:wav_output])

    { output: encoded_wav, title: yt_dlp_title[:title], status: wav_result[:status] }
  end
end
