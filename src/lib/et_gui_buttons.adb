------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                           GUI FOR BUTTONS                                --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2017 - 2026                                                --
-- Mario Blunk / Blunk electronic                                           --
-- Buchfinkenweg 3 / 99097 Erfurt / Germany                                 --
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

with ada.text_io;	use ada.text_io;

with gtk.button;	use gtk.button;

package body et_gui_buttons is

	-- This callback procedure is called each time the
	-- button "add" is clicked.
	procedure cb_add (
		button : access gtk_button_record'class);

	-- This callback procedure is called each time the
	-- button "delete is clicked.
	procedure cb_delete (
		button : access gtk_button_record'class);

	-- This callback procedure is called each time the
	-- button "move" is clicked.
	procedure cb_move (
		button : access gtk_button_record'class);

	-- This callback procedure is called each time the
	-- button "export" is clicked:
	procedure cb_export (
		button : access gtk_button_record'class);

	----------------------------
	-- set_up_command_buttons --
	----------------------------

	procedure set_up_command_buttons (buttons : gtk_buttons) is
	begin
        put_line ("set_up_command_buttons (general)");

		-- Connect button signals with subprograms:

		buttons.button_add.on_clicked (cb_add'access);
		buttons.button_delete.on_clicked (cb_delete'access);
		buttons.button_move.on_clicked (cb_move'access);
		buttons.button_export.on_clicked (cb_export'access);
	end set_up_command_buttons;

	-------------------------
	-- on_zoom_fit_clicked --
	-------------------------

    procedure on_zoom_fit_clicked (
        buttons : gtk_buttons;
        call    : cb_gtk_button_void) is
	begin
		buttons.button_zoom_fit.on_clicked (call);
	end on_zoom_fit_clicked;

	--------------------------
	-- on_zoom_area_clicked --
	--------------------------

    procedure on_zoom_area_clicked (
        buttons : gtk_buttons;
        call    : cb_gtk_button_void) is
	begin
		buttons.button_zoom_area.on_clicked (call);
	end on_zoom_area_clicked;

	------------
	-- cb_add --
	------------

	procedure cb_add (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_add");
		-- add_object;

		-- Redraw the canvas:
--		refresh;
	end cb_add;

	---------------
	-- cb_delete --
	---------------

	procedure cb_delete (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_delete");
		-- delete_object;

		-- Redraw the canvas:
--		refresh;
	end cb_delete;

	-------------
	-- cb_move --
	-------------

	procedure cb_move (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_move");
		-- CS
	end cb_move;

	---------------
	-- cb_export --
	---------------

	procedure cb_export (
		button : access gtk_button_record'class)
	is
	begin
		put_line ("cb_export");
		-- CS
	end cb_export;

end et_gui_buttons;

-- Soli Deo Gloria

-- For God so loved the world that he gave
-- his one and only Son, that whoever believes in him
-- shall not perish but have eternal life.
-- The Bible, John 3.16

