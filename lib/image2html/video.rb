module Image2Html

  class Video
    def initialize(video_path, options={})
      @video_path = video_path
      @options = options
    end

    def make_frames
      `ffmpeg -i #{video_path} -vf "transpose=#{options[:transpose]}" -y -f image2 -s 80x45 tmp/frame%04d.png`
    end

    def make_snapshots
      make_frames
      index = 0
      Dir["#{Image2Html.tmp_path}/frame*.png"].each do |image_path|
        puts "Frame #{index}"
        snapshot = Image2Html::Snapshot.new(image_path, "OMG LOL WTF")
        outfile = File.open(Image2Html.output_path.join("frame#{index}.png"), 'w')
        png = snapshot.to_png
        outfile.write png.read
        outfile.close
        index+=1
      end
    end

    def make_video
      make_snapshots
      `ffmpeg -r 10 -b 1800 -i #{Image2Html.tmp_path}/%04d.png #{Image2Html.output_path}/output.mp4`
    end

    attr_reader :video_path, :options
  end

end
