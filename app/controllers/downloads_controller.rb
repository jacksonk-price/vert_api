class DownloadsController < ApplicationController
  require 'open3'
  require 'colorize'
  require 'yt_dlp_downloader'
  require 'ffmpeg_converter'

  include YoutubeValidation

  def convert
    url = params[:inputurl]

    if valid_url?(url)
      download = Download.new(ip: request.remote_ip, video_url: url)

      download.start_conversion = Time.now

      # youtube provides m4a audio format.
      # download as m4a first
      ytdlp = YtDlpDownloader.new(download.video_url, 'm4a')
      download_result = ytdlp.extract_audio

      unless download_result[:status].success?
        render json: { status: 'error', message: 'Something went wrong during the audio extraction.'}
      end

      title_result = ytdlp.get_video_title

      # now convert m4a to wav
      conversion_result = FfmpegConverter.convert_to_wav(download_result[:audio])
      download.end_conversion = Time.now

      # encode wav binary to base64
      encoded_wav = Base64.encode64(conversion_result[:wav_output])

      if conversion_result[:status].success?
        download.save!

        render json: { status: 'success', message: 'Video successfully converted to audio.', video_title: title_result[:title], wav_base64: encoded_wav }
      else
        render json: { status: 'error', message: 'Something went wrong during conversion.'}
      end
    else
      render json: { status: 'error', message: 'Url is invalid.' }
    end
  end
end