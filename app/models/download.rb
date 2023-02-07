class Download < ApplicationRecord
  include YoutubeDlConfig
  def convert_url
    cmd = build_command(conversion_id, video_url)
    stdout, stderr, status  = Open3.capture3(cmd)
    status
  end
end
