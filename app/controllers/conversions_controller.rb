class ConversionsController < ApplicationController
  require 'yt_dlp_downloader'
  require 'ffmpeg_converter'

  include YoutubeValidation

  def convert
    url = params[:inputurl]

    unless valid_url?(url)
      render json: { status: :unprocessable_entity, message: 'Url is invalid.' }
      return
    end

    Conversion.transaction do
      conversion = Conversion.create!(ip: request.remote_ip, video_url: url)

      conversion.time_start = Time.now

      # youtube provides m4a audio format.
      # extract as m4a first
      ytdlp = YtDlpDownloader.new(url, 'm4a')
      download_result = ytdlp.extract_audio

      unless download_result[:status].success?
        message = 'Something went wrong during the audio extraction.'
        conversion.update!(status: 'error', status_message: message)
        render json: { status: :internal_server_error, message: message }
        return
      end

      title_result = ytdlp.get_video_title

      # now convert m4a to wav
      conversion_result = FfmpegConverter.convert_to_wav(download_result[:audio])
      conversion.time_end = Time.now

      if conversion_result[:status].success?
        message = 'Video successfully converted to audio.'
        conversion.update!(status: 'success', status_message: message)
        # encode wav binary to base64
        encoded_wav = Base64.encode64(conversion_result[:wav_output])

        render json: { status: :ok, message: message, video_title: title_result[:title], wav_base64: encoded_wav }
      else
        message = 'Something went wrong during conversion.'
        conversion.update!(status: 'error', status_message: message)

        render json: { status: :internal_server_error, message: message}
      end
    end
  end
end