class Conversion < ApplicationRecord
  #     t.string "ip"
  #     t.string "video_url"
  #     t.datetime "time_start"
  #     t.datetime "time_end"
  #     t.string "status"
  #     t.string "status_message"
  #     t.string "video_title"
  def convert
    extract_output = extract_video_audio
    self.video_title = extract_video_title

    if extract_output.nil?
      assign_attributes(status: 'error', status_message: 'Something went wrong during the audio extraction.', time_end: Time.now)
      return nil
    end

    conversion_output = convert_to_wav(extract_output)

    if conversion_output.nil?
      assign_attributes(status: 'error', status_message: 'Something went wrong during the audio conversion.', time_end: Time.now)
    else
      assign_attributes(status: 'success', status_message: 'Video successfully converted to audio.', time_end: Time.now)
    end

    self.save

    conversion_output
  end

  private

  def extract_video_audio
    output, status = Open3.capture2(extract_audio_command)

    status.success? ? output : nil
  end

  def extract_video_title
    output, status = Open3.capture2(extract_title_command)

    output = 'untitled' unless status.success?

    output
  end

  def convert_to_wav(m4a_data)
    wav_output, status = Open3.capture2('ffmpeg', '-i', 'pipe:0', '-f', 'wav', 'pipe:1', stdin_data: m4a_data)

    status.success? ? wav_output : nil
  end

  def extract_audio_command
    "yt-dlp -f 'bestaudio[ext=m4a]' --no-continue -o - #{video_url}"
  end

  def extract_title_command
    "yt-dlp --get-title #{video_url}"
  end
end
