class Conversion < ApplicationRecord
  #     t.string "ip"
  #     t.string "video_url"
  #     t.datetime "time_start"
  #     t.datetime "time_end"
  #     t.string "status"
  #     t.string "status_message"
  #     t.string "video_title"
  def extract_video_audio
    output, status = Open3.capture2(extract_audio_command)

    { audio: output, status: status }
  end

  def get_video_title
    output, status = Open3.capture2(extract_title_command)

    output = 'untitled' unless status.success?

    { title: output, status: status }
  end

  def convert_to_wav(m4a_data)
    wav_output, status = Open3.capture2('ffmpeg', '-i', 'pipe:0', '-f', 'wav', 'pipe:1', stdin_data: m4a_data)

    { wav_output: wav_output, status: status }
  end

  private

  def extract_audio_command
    "yt-dlp -f 'bestaudio[ext=m4a]' --no-continue -o - #{video_url}"
  end

  def extract_title_command
    "yt-dlp --get-title #{video_url}"
  end
end
