class DownloadsController < ApplicationController
  require 'open3'
  require 'securerandom'
  require 'stringio'
  require 'colorize'
  require 'open-uri'

  include YoutubeValidation

  def convert
    conversion_id = SecureRandom.uuid
    Rails.logger.info "Created conversion id #{conversion_id}".green

    url = params[:inputurl]

    if valid_url?(url)
      download = Download.new
      download.conversion_id = conversion_id
      download.ip = request.remote_ip
      download.video_url = url

      download.start_conversion = Time.now
      Rails.logger.info "Beginning conversion for #{url} with conversion id: #{conversion_id}...".yellow
      status = download.convert_url
      download.end_conversion = Time.now

      if status.success?
        download.save!
        file_string = File.read("public/user_downloads/#{conversion_id}.mp3")
        encoded_file = Base64.encode64(file_string)
        Rails.logger.info "The audio has been downloaded successfully".green
        File.delete("public/user_downloads/#{conversion_id}.mp3")
        render json: { status: 'success', message: 'Video successfully converted to audio.', mp3_base: encoded_file }
      else
        puts "An error occurred while converting the video."
        render json: { status: 'error', message: 'Something went wrong during conversion'}
      end
    else
      render json: { status: 'error', message: 'Url is invalid' }
    end
  end
end