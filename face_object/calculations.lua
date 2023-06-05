face_object.calc = {} -- This stores all the low-level functions
local _c = face_object.calc
local sin, cos, tan = math.sin, math.cos, math.tan
local deg, rad = math.deg, math.rad
local pi = math.pi

-- Converts a 3D coord to a 2D coord.
-- from: 3D coord
-- return: 2D coord
function _c.to2d(from)
	return {x=from.x,y=from.z}
end

-- Calculates the bearing of `t` from `from`.
-- from and to: tables of x and y
-- return: radian
function _c.facedir(from,to)
	if (from.x == to.x) and (from.y == to.y) then
		return nil
	end

	local offset_to = {
		x = to.x - from.x,
		y = to.y - from.y
	}

	local theta = math.atan2(offset_to.y,offset_to.x) - (pi/2)

	return theta
end

-- Rotate the point by angle theta.
-- This uses the rotation matrix.
-- point: tabel of x and y
-- theta: The rotation angle in radian
-- return: The rotated point
function _c.rotate(point,theta)
	local c_T, s_T = cos(theta), sin(theta)
	return {
		x = (point.x * c_T) - (point.y * s_T),
		y = (point.x * s_T) + (point.y * c_T)
	}
end

-- Rotate a table of points by a common theta.
-- This uses the rotation matrix.
-- _c.rotate is not reused as it calculates sin and cos every time.
-- point: table of points
-- theta: The rotation angle in radian
-- return: table of he rotated point
function _c.rotate_list(points,theta)
	local returnd = {}
	local c_T, s_T = cos(theta), sin(theta)
	for i,v in pairs(points) do
		returnd[i] = {
			x = (v.x * c_T) - (v.y * s_T),
			y = (v.x * s_T) + (v.y * c_T)
		}
	end
	return returnd
end

-- Move the point(s).
-- points: a point or a table of points
-- offset: table of x and y offset
-- return: a point of a table of points
function _c.move(points,offset)
	if points.x and points.y then
		return _c.move({points},offset)[1]
	end

	local rd = {}
	for k,v in pairs(points) do
		rd[k] = {
			x = v.x + offset.x,
			y = v.y + offset.y
		}
	end
	return rd
end

-- Avoid repeated calculations
local C30, S30 = cos(rad(30)), sin(rad(30))
-- Generate the vertices of a equilateral triangle from its altitudes
-- If rotation is needed, pass the returned list to _c.rotate_list.
-- The center is (0,0). Pass the table into _c.move to move its center to somewhere.
-- altitudes: the length of altitudes
-- return: table of vertices
function _c.eq_triangle(altitudes)
	local rd = {{},{},{}}

	rd[1].x = (C30 * altitudes)
	rd[1].y = (S30 * altitudes)

	rd[2].x = 0
	rd[2].y = altitudes * -1

	rd[3].x = (C30 * altitudes) * -1
	rd[3].y = (S30 * altitudes)

	return rd
end

local S45, C45 = sin(rad(45)), cos(rad(45))
-- Generate the vertices of a square from its circumradius
-- If rotation is needed, pass the returned list to _c.rotate_list.
-- The center is (0,0). Pass the table into _c.move to move its center to somewhere.
-- circumradius: the length of circumradius
-- return: table of vertices
function _c.square(center, circumradius)
	local rd = {{},{},{},{}}

	rd[1].x = (S45 * circumradius)
	rd[1].y = (C45 * circumradius)

	rd[2].x = rd[1].x * -1
	rd[2].y = rd[1].y

	rd[3].x = rd[1].x * -1
	rd[3].y = rd[1].y * -1

	rd[4].x = rd[1].x
	rd[4].y = rd[1].y * -1

	return rd
end


