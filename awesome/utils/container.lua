local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")

local M = {}

local function val(v, df)
	if v == nil then return df end
	return v
end

local function set_geometry(self, x, y, w, h)
	self.x = x
	self.y = y
	self.width = w
	self.height = h
end

function M.awbar(cfg)
	cfg = cfg or {}

	local position = val(cfg.position, "top")
	local margin   = val(cfg.margin, 0)

	local w = val(cfg.width, 600)
	local h = val(cfg.height, 25)
	if position == "left" or position == "right" then
		w, h = h, w
	end

	local df = {
		screen   = cfg.screen,
		ontop    = val(cfg.ontop, true),
		visible  = val(cfg.visible, true),
		bg       = val(cfg.bg, beautiful.bg_normal),
		position = position,
		stretch  = cfg.stretch ~= false,
		width    = w,
		height   = h,
		align    = val(cfg.align, "center"),
		margin   = margin,
		round    = val(cfg.round, 0),
	}

	if df.stretch and df.screen then
		if df.position == "top" or df.position == "bottom" then
			df.width = df.screen.geometry.width
		else
			df.height = df.screen.geometry.height
		end
	end

	if df.position == "top" then
		df.y = 0
	elseif df.position == "bottom" then
		df.y = df.screen.geometry.height - df.height
	elseif df.position == "left" then
		df.x = 0
	elseif df.position == "right" then
		df.x = df.screen.geometry.width - df.width
	end

	local align_factor
	if df.align == "right" then
		align_factor = 1
	elseif df.align == "left" then
		align_factor = 0
	else
		align_factor = 0.5
	end

	if df.position == "top" or df.position == "bottom" then
		df.x = (df.screen.geometry.width - df.width) * align_factor
	else
		df.y = (df.screen.geometry.height - df.height) * align_factor
	end

	if margin > 0 then
		if df.position == "top" or df.position == "bottom" then
			df.width = df.width - margin * 2
			df.x     = df.x + margin

			if df.position == "bottom" then
				df.y = df.y - margin
			else
				df.y = df.y + margin
			end
		else
			df.height = df.height - margin * 2
			df.y      = df.y + margin
			if df.position == "right" then
				df.x = df.x - margin
			else
				df.x = df.x + margin
			end
		end
	end

	local struts
	if df.position == "top" or df.position == "bottom" then
		struts = df.height + margin
	else
		struts = df.width + margin
	end

	df.shape = function (cr, w, h)
		gears.shape.rounded_rect(cr, w, h, df.round)
	end

	local presets = {
		screen  = df.screen,
		ontop   = df.ontop,
		visible = df.visible,
		width   = df.width,
		height  = df.height,
		bg      = df.bg,
		x       = df.x,
		y       = df.y,
		type    = df.type,
		shape   = df.shape
	}

	local box = wibox(presets)
	box.cfg = df
	box.cfg.df = {
		x      = df.x,
		y      = df.y,
		width  = df.width,
		height = df.height,
		shape  = df.shape,
	}
	box.maximized = false

	box:struts { [df.position] = struts }

	box.maximize = function (self)
		local g   = self.screen.geometry
		local pos = self.cfg.position

		if pos == "top" then
			set_geometry(self, 0, 0, g.width, self.height)
			self:struts { top = self.height }
		elseif pos == "bottom" then
			set_geometry(self, 0, g.height - self.height, g.width, self.height)
			self:struts { bottom = self.height }
		elseif pos == "left" then
			set_geometry(self, 0, 0, self.width, g.height)
			self:struts { left = self.width }
		elseif pos == "right" then
			set_geometry(self, g.width - self.width, 0, self.width, g.height)
			self:struts { right = self.width }
		end

		self.shape = gears.shape.rectangle
		self.maximized = true
	end

	box.minimize = function (self)
		local df = self.cfg.df
		set_geometry(self, df.x, df.y, df.width, df.height)
		self.shape = df.shape
		self:struts { [self.cfg.position] = struts }
		self.maximized = false
	end

	box.show   = function (self) self.visible = true end
	box.hide   = function (self) self.visible = false end
	box.toggle = function (self) self.visible = not self.visible end

	return box
end

return M
