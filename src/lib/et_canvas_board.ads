------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                           CANVAS FOR BOARD                               --
--                                                                          --
--                               S p e c                                    --
--                                                                          --
--         Copyright (C) 2017 - 2022 Mario Blunk, Blunk electronic          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your editor to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--
-- DESCRIPTION:
-- 
-- This package draws the pcb layout (board) via various child packages.
-- This package instantiates the generic canvas package (et_canvas_general.pac_canvas)
-- and extends the type_view by the type_drawing. The latter is the link
-- to the actual drawing. The type_drawing provides information on sheet size,
-- fame bounding box, paper size etc. This information is frequently used
-- by various draw operations.
--  Further-on the generic package for primitve draw operations (et_canvas_draw.pac_draw)
-- is instantiated here so that lots of draw operations can use pac_draw_package.

with gdk.types;						use gdk.types;
with gdk.types.keysyms;				use gdk.types.keysyms;

with gtk;
with gtk.gentry;					use gtk.gentry;

with glib;							use glib;
with cairo;							use cairo;

with et_net_names;					use et_net_names;
with et_general;					use et_general;
with et_geometry;					use et_geometry;

with et_pcb_coordinates;			use et_pcb_coordinates;
use et_pcb_coordinates.pac_geometry_brd;
use et_pcb_coordinates.pac_geometry_2;

with et_board_shapes_and_text;		use et_board_shapes_and_text;
with et_vias;						use et_vias;
with et_terminals;					use et_terminals;
with et_conductor_segment;
with et_packages;
with et_project.modules;			use et_project.modules;
with et_schematic;
with et_frames;

with et_canvas_general;				use et_canvas_general;
with et_string_processing;			use et_string_processing;
with et_logging;					use et_logging;


package et_canvas_board is

	use pac_text_board;
	
	use pac_net_name;

	-- This procedure should be called each time after the current active module 
	-- changes. It calls procedures that initialize the values used in property
	-- bars for vias, tracks, ...
	procedure init_property_bars;


	
	title : constant string := system_name & " BOARD ";
	
	procedure set_title_bar (
		-- CS project name								
		module		: in pac_module_name.bounded_string);


	
	-- Instantiate the general canvas package:
	package pac_canvas is new et_canvas_general.pac_canvas (
		canvas_name		=> "board", -- CS provide domain name like scripting.type_domain
		pac_geometry_2	=> et_pcb_coordinates.pac_geometry_2,
		pac_polygons	=> et_board_shapes_and_text.pac_polygons,
		pac_offsetting	=> et_board_shapes_and_text.pac_polygon_offsetting,
		pac_contours	=> et_board_shapes_and_text.pac_contours,
		pac_text		=> et_board_shapes_and_text.pac_text_board);
	
	use pac_canvas;	


	
	-- Frequently used things to draw the board layout:
	type type_drawing is null record;

	

-- 	-- Initializes the internal data so that the model can send signals:
-- 	procedure init (self : not null access type_model'class);



	
	-- Composes a console command like 
	-- "board motor_driver execute script my_script.scr"
	-- and sends it to procedure et_scripting.board_cmd
	-- to be executed.:
	procedure execute_script (script : in pac_script_name.bounded_string);	

	-- Executes a command as typed on the console by the operator
	-- like "rename device R1 R2".
	-- Calls et_scripting.board_cmd for the actual execution.
	procedure execute_command (self : access gtk_entry_record'class);

	

-- VIEW OR CANVAS
	
	type type_view is new pac_canvas.type_view with record
		drawing	: type_drawing;
	end record;


	-- Appends the et_canvas_schematic.label_console_text to the existing text
	-- of label_console:
	procedure set_label_console;


	
	procedure redraw_board;
	procedure redraw_schematic;
	procedure redraw;

	


	
	overriding function bounding_box (self : not null access type_view)
		return type_bounding_box;

		
	overriding function model_to_drawing (
		self		: not null access type_view;
		model_point : in type_model_point)
		return type_point;

		
	overriding function drawing_to_model (
		self			: not null access type_view;
		drawing_point : in type_point)	
		return type_model_point;



	-- These procedures set the grid as entered in the grid box:
		
	procedure set_grid_x (self : access gtk.gentry.gtk_entry_record'class);
	-- Additionally sets the grid for y. Mostly grid of x and y axis are the same.
	
	procedure set_grid_y (self : access gtk.gentry.gtk_entry_record'class);


	-- Multiplier for grid densities:
	grid_density_multiplier_coarse	: constant type_distance_positive := 10.0;
	grid_density_multiplier_normal	: constant type_distance_positive := 1.0;
	grid_density_multiplier_fine	: constant type_distance_positive := 0.25;	

	
	

	-- Creates a new board view:
	procedure gtk_new (
		self	: out type_view_ptr);
	
	-- Redraws either the whole board view, or a specific part of it only:
	overriding procedure draw_internal (
		self	: not null access type_view;
		area_in	: type_bounding_box);


	overriding procedure move_cursor (
		self		: not null access type_view;
		coordinates	: in type_coordinates;  -- relative/absolute
		cursor		: in out type_cursor;
		position	: in type_point);

	overriding procedure move_cursor (
		self		: not null access type_view;
		direction	: in type_cursor_direction; -- right, left, up, down
		cursor		: in out type_cursor);


	
	cursor_line_width : constant type_distance_positive := 0.8;
	cursor_half_size : constant type_distance_positive := 50.0;
	type type_cursor_line is new et_pcb_coordinates.pac_geometry_2.type_line with null record;
	-- CS: Cursor stuff must be based on float numbers.
	
	
	overriding procedure draw_cursor (
		self		: not null access type_view;
		cursor		: in type_cursor);

	
	overriding function get_grid (
		self : not null access type_view)
		return type_grid;

		
	overriding function get_frame (
		self : not null access type_view)
		return et_frames.type_frame;

		
	overriding function get_frame_height (
		self : not null access type_view)
		return type_float_positive;

		
	overriding function frame_width (
		self : not null access type_view)
		return type_float_positive;
	
		
	overriding function title_block_position (
		self : not null access type_view)
		return et_frames.type_position;

		
	-- Returns the position of the board origin relative to the lower left
	-- corner of the drawing frame:
	function board_origin (
		self : not null access type_view)
		return type_model_point;

	
	overriding function get_verb (
		self	: not null access type_view)
		return string;

	overriding function get_noun (
		self	: not null access type_view)
		return string;

	
	overriding procedure key_pressed (
		self		: not null access type_view;
		key			: in gdk_key_type;
		key_shift	: in gdk_modifier_type);

	overriding procedure mouse_moved (
		self	: not null access type_view;
		point	: in type_point);
	
	overriding procedure button_pressed (
		self	: not null access type_view;
		button	: in type_mouse_button;
		point	: in type_point);

	-- Saves the current module by calling 
	-- et_canvas_schematic.save_module:
	overriding procedure save_drawing (
		self : not null access type_view);


	
-- UNDO / REDO:
	
	overriding procedure undo (
		self : not null access type_view);

	overriding procedure redo (
		self : not null access type_view);

	
end et_canvas_board;

-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
