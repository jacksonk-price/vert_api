class DownloadsController < ApplicationController
  require 'open3'
  require 'colorize'

  include YoutubeValidation

  def convert
    url = params[:inputurl]

    if valid_url?(url)
      download = Download.new(ip: request.remote_ip, video_url: url)

      download.start_conversion = Time.now
      result = download.convert_url
      download.end_conversion = Time.now
      puts result[:title]

      if result[:status].success?
        download.save!

        render json: { status: 'success', message: 'Video successfully converted to audio.', video_title: result[:title], wav_base64: result[:output]}
      else
        render json: { status: 'error', message: 'Something went wrong during conversion.'}
      end
    else
      render json: { status: 'error', message: 'Url is invalid.' }
    end
  end
end