class FfmpegConverter
  def self.convert_to_wav(m4a_data)
    wav_output, status = Open3.capture2('ffmpeg', '-i', 'pipe:0', '-f', 'wav', 'pipe:1', stdin_data: m4a_data)

    { wav_output: wav_output, status: status }
  end
end