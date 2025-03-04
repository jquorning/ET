------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                        SCHEMATIC COORDINATES                             --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
--         Copyright (C) 2017 - 2022 Mario Blunk, Blunk electronic          --
--                                                                          --
--    This program is free software: you can redistribute it and/or modify  --
--    it under the terms of the GNU General Public License as published by  --
--    the Free Software Foundation, either version 3 of the License, or     --
--    (at your option) any later version.                                   --
--                                                                          --
--    This program is distributed in the hope that it will be useful,       --
--    but WITHOUT ANY WARRANTY; without even the implied warranty of        --
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
--    GNU General Public License for more details.                          --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--    along with this program.  If not, see <http://www.gnu.org/licenses/>. --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your edtior to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--

with system.assertions;
with ada.exceptions;

with ada.numerics.generic_elementary_functions;

package body et_coordinates is
-- 	pragma assertion_policy (check);

	
	function to_angle (angle : in string) return type_rotation is 
		r : type_rotation;
	begin
		r := type_rotation'value (angle);
		return r;

		exception 
			when constraint_error => 
				log (ERROR, "Rotation " & angle & " outside range" & 
					 to_string (type_rotation'first) &
					 " .." & 
					 to_string (type_rotation'last) &
					 " (must be an integer) !",
					 console => true
					);
				raise;

			-- CS check for multiple of 90 degree
			when system.assertions.assert_failure =>
				log (ERROR, "Rotation " & angle & " is not a multiple of" &
					 to_string (rotation => type_rotation'small) & " !",
					 console => true
					);
				raise;
				
			when others =>
				raise;
	end to_angle;
	
	function to_sheet (sheet : in type_sheet) return string is begin
		return type_sheet'image (sheet);
	end;

	function to_sheet (sheet : in string) return type_sheet is begin
		return type_sheet'value (sheet);
	end;

	function to_sheet_relative (sheet : in type_sheet_relative) return string is begin
		return type_sheet_relative'image (sheet);
	end;
	
	function to_sheet_relative (sheet : in string) return type_sheet_relative is begin
		return type_sheet_relative'value (sheet);
	end;

	
	function "<" (left, right : in type_position) return boolean is
		result : boolean := false;
	begin
		if left.sheet < right.sheet then
			result := true;
		elsif left.sheet > right.sheet then
			result := false;
		else
			-- sheet numbers are equal -> compare x
			
			if get_x (left) < get_x (right) then
				result := true;
			elsif get_x (left) > get_x (right) then
				result := false;
			else 
				-- x positions equal -> compare y
				
				if get_y (left) < get_y (right) then
					result := true;
				elsif get_y (left) > get_y (right) then
					result := false;
				else
					-- y positions equal -> compare rotation

					if get_rotation (left) < get_rotation (right) then
						result := true;
					elsif get_rotation (left) > get_rotation (right) then
						result := false;
					else
						-- rotations equal
						result := false;
					end if;
				end if;

			end if;
		end if;
			
		return result;
	end;

	
	procedure move (
		position	: in out type_position'class;
		offset		: in type_position_relative) 
	is
		use et_geometry;
	begin
		position.set (X, get_x (position) + get_x (offset));
		position.set (Y, get_y (position) + get_y (offset));

		-- Constraint error will arise here if resulting sheet number is less than 1.
		position.sheet := type_sheet (type_sheet_relative (position.sheet) + offset.sheet);
	end;

	
	function to_position (
		point 		: in type_point;
		sheet		: in type_sheet;
		rotation	: in type_rotation := zero_rotation)
		return type_position 
	is
		p : type_position;
	begin
		set (p, point);
		set_sheet (p, sheet);
		set (p, rotation);
		return p;
	end;

	
	function to_position_relative (
		point 		: in type_point;
		sheet		: in type_sheet_relative;
		rotation	: in type_rotation := zero_rotation)
		return type_position_relative 
	is
		p : type_position_relative;
	begin
		set (p, point);
		p.sheet := sheet;
		set (p, rotation);
		return p;
	end;

	
	function to_string (position : in type_position) return string is

		coordinates_preamble_sheet : constant string := " pos "
			& "(sheet"
			& axis_separator
			& "x"
			& axis_separator
			& "y) ";

	begin
		return coordinates_preamble_sheet
			& to_sheet (position.sheet) 
			& space & axis_separator & space
			& to_string (get_x (position))
			& space & axis_separator & space
			& to_string (get_y (position));
	end to_string;

	
	function get_sheet (
		position	: in type_position) 
		return type_sheet 
	is begin
		return position.sheet;
	end get_sheet;

	
	procedure set_sheet (
		position	: in out type_position;
		sheet		: in type_sheet) 
	is begin
		position.sheet := sheet;
	end set_sheet;


	
end et_coordinates;

-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
