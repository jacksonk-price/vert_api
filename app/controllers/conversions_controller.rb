class ConversionsController < ApplicationController
  before_action :validate_url

  def create
    url = conversion_params[:input_url]
    conversion = Conversion.new(ip: request.remote_ip, video_url: url, time_start: Time.now)

    conversion_output = conversion.convert

    if conversion.status == 'error'
      render_response(conversion)
    else
      encoded_wav = Base64.encode64(conversion_output)

      render_response(conversion, encoded_wav)
    end
  end

  private

  def validate_url
    unless YoutubeValidator.valid_url?(conversion_params[:input_url])
      render json: { message: 'Url is invalid' }, status: :unprocessable_entity
    end
  end

  def render_response(conversion, encoded_wav=nil)
    if encoded_wav.nil?
      render json: { message: conversion.status_message }, status: :internal_server_error
    else
      render json: { message: conversion.status_message, video_title: conversion.video_title, wav_base64: encoded_wav }, status: :ok
    end
  end

  def conversion_params
    params.require(:conversion).permit(:input_url)
  end
end