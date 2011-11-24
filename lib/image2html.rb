require 'rubygems'
require 'bundler'

Bundler.setup

require 'cairo'

surface = Cairo::ImageSurface.from_png("/Users/teejayvanslyke/Downloads/hamburger-icon.png")

$text = %{A hamburger (also known as simply a burger) is a sandwich consisting of a cooked patty of ground meat (usually beef, but occasionally pork or a combination of meats) usually placed inside a sliced bread roll. Hamburgers are often served with lettuce, bacon, tomato, onion, pickles, cheese and condiments such as mustard, mayonnaise, ketchup and relish.}

def character(index)
  $text[index % $text.length - 1].gsub(' ', '&nbsp;')
end

def pixels(surface)
  surface.data.unpack("C*").each_slice(4).to_a
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

html = STDOUT

html << %{<div style="font-family: Helvetica; font-size: 12px; text-align: right">}

pixels = pixels(surface)

pixel = 0
character = 0
surface.height.times do |row|

  html << %{<div class="row" style="padding:0; margin:0; clear:both">}

  surface.width.times do |column|
    r, g, b  = pixels[pixel][2], pixels[pixel][1], pixels[pixel][0]
    html << %{<div class="pixel" style="float:left; width: 14px; height: 16px; padding-right: 2px; color: #{text_color_for_background(r,g,b)}; background-color: rgb(#{[r,g,b].join(',')})">#{character(pixel)}</div>}
    pixel += 1
  end

  html << %{</div>}
end

html << %{</div>}


