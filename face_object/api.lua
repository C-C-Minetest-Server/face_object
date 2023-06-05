local _c = face_object.calc

-- Object faces a position
-- obj: the ObjectRef to be altered
-- pos: the position to be looked at
-- result: the object looks at the pos
function face_object.face_pos(obj, pos)
	local obj_pos = obj:get_pos()
	local facedir = _c.facedir(_c.to2d(obj_pos),_c.to2d(pos))
	if not facedir then return false end
	if obj:is_player() then
		obj:set_look_horizontal(facedir)
	else
		obj:set_yaw(facedir)
	end
	return true
end

-- Object faces an object
-- obj1: the object to be altered
-- obj2: the object to be ooked at
function face_object.face_object(obj1,obj2)
	face_object.face_pos(obj1, obj2:get_pos())
end

-- Two objects look at each other
-- obj1, obj2: ObjectRef
function face_object.face_each_other(obj1,obj2)
	face_object.face_object(obj1,obj2)
	face_object.face_object(obj2,obj1)
end
