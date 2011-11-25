module Image2Html

  class Snapshot
    def initialize(image_path, text)
      @html_file  = Tempfile.new('image2html')
      @image_file = Tempfile.new('image2html')
      @image = Image2Html::Base.new(image_path, text, @html_file)
      @image.write
      @html_file.close
      @image_file.close
    end

    def snap
      puts "Snapping"
      `macruby -r #{File.dirname(__FILE__) + '/snapper.rb'} -e \"Snapper.new(:width => #{@image.width}, :height => #{@image.height}).save('file://#{@html_file.path}', '#{@image_file.path}')\"`
    end

    def to_png
      snap
      File.open(@image_file.path)
    end
  end

end
