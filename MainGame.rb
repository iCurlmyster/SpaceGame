#!/usr/bin/ruby

require 'gosu'

class Player 
	attr_accessor :score
	def initialize window
		@main_guy = Gosu::Image.new window, "Spaceship.png",false
		@x = @y = @xvel = @yvel = @angle = 0.0
		@score = 0
	end

	def position x,y
		@x = x
		@y = y
	end

	def turn_left
		@angle -= 4.5
	end

	def turn_right
		@angle += 4.5
	end

	def accelerate
		@xvel += Gosu::offset_x(@angle,0.5)
		@yvel += Gosu::offset_y(@angle,0.5)
	end

	def collect stars
		if stars.reject! do |star| Gosu::distance(@x,@y,star.x,star.y) < 35 end
			@score += 1
		end
	end

	def move
		@x += @xvel
		@y += @yvel
		@x %= 700
		@y %= 500

		@xvel *= 0.95
		@yvel *= 0.95
	end

	def draw
		@main_guy.draw_rot(@x,@y,1,@angle,0.5,0.5,0.2,0.2) # params (xpos,ypos,zpos,angle,centerx,centery,sizex,sizey)
	end
end

class Star 
	attr_accessor :x, :y
	def initialize window
		@img = Gosu::Image.new window,"Star.png",false
		@x = @y = @angle = 0.0
	end

	def position x,y
		@x = x
		@y = y
	end

	def getPosition
		"#{@x} #{@y}"
	end

	def spin
		@angle += 0.2
	end

	def draw
		@img.draw_rot @x,@y,1,@angle,0.5,0.5,0.1,0.1
	end
end

class GameWindow < Gosu::Window

	def initialize
		super 700,500,false
		self.caption = "Space Thing!"

		@player1 = Player.new self
	
		start

		@background_img = Gosu::Image.new self,"Space.jpg",false


		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
		@win_title = Gosu::Font.new(self, Gosu::default_font_name, 50)

	end

	def start
		@player1.position 700/2,500/2

		@starArray = [Star.new(self),Star.new(self),Star.new(self),Star.new(self),Star.new(self),Star.new(self),Star.new(self)]
		
		@starArray.each do | obj |
			obj.position Random.new.rand(1..650),Random.new.rand(1..450)
		end
	end

	def draw
		@player1.draw
		@background_img.draw 0,0,0
		@starArray.each do | obj |
			obj.draw
		end
		@font.draw("Score: #{@player1.score}",10,10,2,1,1,Gosu::Color.argb(0xffff0000))
		if (@player1.score == 7)
			@win_title.draw("You Won!",500/2,300/2,2,1,1,Gosu::Color.argb(0xff00ffff))
		end
	end

	def update

		if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then 
			@player1.turn_left
		end
		if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
			@player1.turn_right
		end
		if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
			@player1.accelerate
		end
		@player1.move
		@starArray.each do | obj |
			obj.spin
		end
		@player1.collect(@starArray)


	end

	def button_down id
		if id == Gosu::KbEscape
			close
		end
		if id == Gosu::KbR then
			start
			@player1.score = 0
		end
	end

end




window = GameWindow.new
window.show
