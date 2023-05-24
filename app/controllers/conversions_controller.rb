class ConversionsController < ApplicationController
  include YoutubeValidation

  def create
    url = params[:input_url]

    unless valid_url?(url)
      render json: { message: 'Url is invalid' }, status: :unprocessable_entity
      return
    end

    conversion = Conversion.new(ip: request.remote_ip, video_url: url, time_start: Time.now)
    title_result = conversion.get_video_title
    conversion.video_title = title_result[:title]
    extract_result = conversion.extract_video_audio

    unless extract_result[:status].success?
      message = 'Something went wrong during the audio extraction'
      conversion.assign_attributes(status: 'error', status_message: message)
      conversion.save

      render_response(conversion)
      return
    end

    conversion_result = conversion.convert_to_wav(extract_result[:audio])

    if conversion_result[:status].success?
      message = 'Video successfully converted to audio'
      conversion.assign_attributes(status: 'success', status_message: message)
      conversion.save
      encoded_wav = Base64.encode64(conversion_result[:wav_output])

      render_response(conversion, encoded_wav)
    else
      message = 'Something went wrong during conversion'
      conversion.assign_attributes(status: 'error', status_message: message)
      conversion.save

      render_response(conversion)
    end
  end

  private

  def render_response(conversion, encoded_wav=nil)
    if encoded_wav.nil?
      render json: { message: conversion.status_message }, status: :internal_server_error
    else
      render json: { message: conversion.status_message, video_title: conversion.video_title, wav_base64: encoded_wav }, status: :ok
    end
  end
end