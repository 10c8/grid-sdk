--========= Copyright © 2013-2015, Planimeter, All rights reserved. ==========--
--
-- Purpose: Frame HUD
--
--============================================================================--

class "hudframe" ( gui.frame )

function hudframe:hudframe( parent, name, title )
	gui.frame.frame( self, parent, name, title )

	self:setResizable( false )
	self:setMovable( false )

	if ( self.closeButton ) then
		self.closeButton:remove()
		self.closeButton = nil
	end

	self:setUseFullscreenFramebuffer( false )
	self:invalidateLayout()
end

local HUDFRAME_ANIM_TIME = 0.2

function hudframe:activate()
	if ( not self:isVisible() ) then
		self:setOpacity( 0 )
		self:animate( {
			opacity = 1
		}, HUDFRAME_ANIM_TIME, "easeOutQuint" )
	end

	self:moveToFront()
	self:setVisible( true )
end

function hudframe:close()
	if ( self.closing ) then
		return
	end

	self.closing = true

	self:animate( {
		opacity = 0,
	}, HUDFRAME_ANIM_TIME, "easeOutQuint", function()
		self:setVisible( false )
		self:setOpacity( 1 )

		self.closing = nil
	end )
end

function hudframe:draw()
	self:drawBlur()
	gui.frame.draw( self )
end

function hudframe:drawBackground()
	if ( not gui.blurFramebuffer ) then
		gui.frame.drawBackground( self )
		return
	end

	graphics.setColor( self:getScheme( "hudframe.backgroundColor" ) )
	graphics.rectangle( "fill", 0, 0, self:getWidth(), self:getHeight() )
end

function hudframe:drawBlur()
	if ( not gui.blurFramebuffer ) then
		return
	end

	graphics.push()
		local x, y = self:localToScreen()
		graphics.translate( -x, -y )
		gui.blurFramebuffer:draw()
	graphics.pop()
end

function hudframe:drawTitle()
	local property = "frame.titleTextColor"
	graphics.setColor( self:getScheme( property ) )
	local font = self:getScheme( "titleFont" )
	graphics.setFont( font )
	local x = point( 36 )
	local y = x - point( 4 )
	graphics.print( string.utf8upper( self:getTitle() ), x, y )
end

function hudframe:update( dt )
	if ( gui.blurFramebuffer and self:isVisible() ) then
		self:invalidate()
	end

	gui.frame.update( self, dt )
end

gui.register( hudframe, "hudframe" )
