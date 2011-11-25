module Image2Html

  class Base

    def initialize(image_path, text=" ", out=STDOUT)
      @path = image_path
      @text = text
      @out  = out
    end

    attr_reader :path, :text, :out

    def surface
      @surface ||= Cairo::ImageSurface.from_png(path)
    end

    PIXEL_SIZE=16

    def width
      surface.width * PIXEL_SIZE
    end

    def height
      surface.height * PIXEL_SIZE
    end

    def character(index)
      @text[index % @text.length - 1].gsub(' ', '&nbsp;')
    end

    def pixels
      @pixels ||= surface.data.unpack("C*").each_slice(4).to_a
    end

    def brightness(r, g, b) 
      return ((r * 299) + (g * 587) + (b * 114)) / 1000
    end

    def text_color_for_background(r, g, b)
      if (b = brightness(r, g, b)) > 128
        base = b - 96
      else
        base = b + 96
      end

      return "rgb(#{base}, #{base}, #{base})"
    end

    def write 
      puts "Writing"
      out << %{<html><body style="margin:0; padding:0"><div style="font-family: Helvetica; font-size: 12px; text-align: right">}

      pixel     = 0
      character = 0

      surface.height.times do |row|
        out << %{<div class="row" style="padding:0; margin:0; clear:both">}
        surface.width.times do |column|
          r, g, b  = pixels[pixel][2], pixels[pixel][1], pixels[pixel][0]
          out << %{<div class="pixel" style="float:left; width: #{PIXEL_SIZE-2}px; height: #{PIXEL_SIZE}px; padding-right: 2px; color: #{text_color_for_background(r,g,b)}; background-color: rgb(#{[r,g,b].join(',')})">#{character(pixel)}</div>}
          pixel += 1
        end

        out << %{</div>}
      end

      out << %{</div></body></html>}
    end
  end
end


