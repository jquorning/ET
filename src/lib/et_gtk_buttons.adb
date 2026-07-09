------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                       GTK WIDGET FOR BUTTONS                             --
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

with glib.object;	use glib.object;

with gtk.button;	use gtk.button;
with gtk.table;		use gtk.table;
with gtk.widget;	use gtk.widget;

package body et_gtk_buttons is

	buttons_class : aliased glib.object.ada_gobject_class :=
		glib.object.uninitialized_class;

	procedure initialize (Self : not null access gtk_buttons_record'class);
	function get_type return glib.gtype;

	procedure class_init (self : gobject_class);
	pragma convention (c, class_init);
	--  The class virtual-method handlers. They receive the widget as the raw
	--  C pointer and recover the Ada object through Glib.Object.Get_User_Data.

	----------------
	-- class_init --
	----------------

	procedure class_init (self : gobject_class) is
	begin
		null;
	end class_init;

	--------------
	-- get_type --
	--------------

	function get_type return glib.gtype is
	begin
		glib.object.initialize_class_record (
			ancestor     => gtk.table.get_type,
			class_record => buttons_class,
			type_name    => "et_gtk_buttons",
			class_init   => class_init'access);
		return buttons_class.the_type;
	end get_type;

	----------------
	-- initialize --
	----------------

	procedure initialize (self : not null access gtk_buttons_record'class) is
		use glib.object;
	begin
		g_new (self, get_type);
	end initialize;

	---------------------
	-- gtk_buttons_new --
	---------------------

	procedure gtk_buttons_new (self : out gtk_buttons) is
	begin
        put_line ("gtk_buttons_new");

		self := new gtk_buttons_record;
		gtk.table.initialize (self, rows => 5, columns => 1,
			homogeneous => false);

        gtk_new (self.button_zoom_fit, "ZOOM FIT");
        gtk_new (self.button_zoom_area, "ZOOM AREA");
        gtk_new (self.button_add, "ADD");
        gtk_new (self.button_delete, "DELETE");
        gtk_new (self.button_move, "MOVE");
        gtk_new (self.button_export, "EXPORT");
        -- CS add other buttons

        self.attach (self.button_zoom_fit,
            left_attach => 0, right_attach => 1,
            top_attach  => 0, bottom_attach => 1);

        self.attach (self.button_zoom_area,
            left_attach => 0, right_attach => 1,
            top_attach  => 1, bottom_attach => 2);

        self.attach (self.button_add,
            left_attach => 0, right_attach => 1,
            top_attach  => 2, bottom_attach => 3);

        self.attach (self.button_delete,
            left_attach => 0, right_attach => 1,
            top_attach  => 3, bottom_attach => 4);

        self.attach (self.button_move,
            left_attach => 0, right_attach => 1,
            top_attach  => 4, bottom_attach => 5);

        self.attach (self.button_export,
            left_attach => 0, right_attach => 1,
            top_attach  => 5, bottom_attach => 6);

		et_gtk_buttons.initialize (self);
	end gtk_buttons_new;

end et_gtk_buttons;

-- Soli Deo Gloria

-- For God so loved the world that he gave
-- his one and only Son, that whoever believes in him
-- shall not perish but have eternal life.
-- The Bible, John 3.16

