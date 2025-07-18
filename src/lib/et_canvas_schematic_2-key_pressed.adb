------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                        CANVAS FOR SCHEMATIC                              --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2017 - 2025                                                -- 
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
-- <http://www.gnu.org/licenses/>.   
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

with et_modes.schematic;				use et_modes.schematic;
with et_device_library;					use et_device_library;
with et_device_placeholders;			use et_device_placeholders;
with et_net_names;						use et_net_names;
with et_net_labels;						use et_net_labels;
with et_nets;							use et_nets;
with et_text;							use et_text;
with et_schematic_verb_noun_keys;		use et_schematic_verb_noun_keys;


separate (et_canvas_schematic_2)

procedure key_pressed (
	key			: in gdk_key_type;
	key_shift	: in gdk_modifier_type)
is
	use gdk.types;
	use gdk.types.keysyms;

	use et_modes;
	use et_canvas_schematic_nets;
	use et_canvas_schematic_units;


	point : type_vector_model renames get_cursor_position;

	
	
	procedure delete is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_label =>
				noun := NOUN_LABEL;
				set_status (et_canvas_schematic_nets.status_delete);
				
			when key_noun_unit =>
				noun := NOUN_UNIT;					
				set_status (et_canvas_schematic_units.status_delete);
				
			when key_noun_net_all_sheets =>
				noun := NOUN_NET;
				et_schematic_ops.nets.modify_net_on_all_sheets := true;
				set_status (et_canvas_schematic_nets.status_delete);

			when key_noun_net =>
				noun := NOUN_NET;					
				et_schematic_ops.nets.modify_net_on_all_sheets := false;
				set_status (et_canvas_schematic_nets.status_delete);
				
			when key_noun_strand =>
				noun := NOUN_STRAND;					
				set_status (et_canvas_schematic_nets.status_delete);
				
			when key_noun_segment =>
				noun := NOUN_SEGMENT;				
				set_status (et_canvas_schematic_nets.status_delete);


				
				
			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					when NOUN_LABEL | NOUN_NET | NOUN_STRAND | NOUN_SEGMENT => 
						et_canvas_schematic_nets.delete_object (point);
						
					when NOUN_UNIT =>
						et_canvas_schematic_units.delete_object (point);
						
					when others => null;							
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_LABEL | NOUN_NET | NOUN_STRAND | NOUN_SEGMENT => 
						if clarification_pending then
							et_canvas_schematic_nets.clarify_object;
						end if;

					when NOUN_UNIT =>
						if clarification_pending then
							et_canvas_schematic_units.clarify_object;
						end if;

					when others =>
						null;
						
				end case;

				
			when others => status_noun_invalid;
		end case;
	end delete;

	

	
	procedure drag is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_segment =>
				noun := NOUN_SEGMENT;
				set_status (et_canvas_schematic_nets.status_drag);

				-- When dragging net segments, we enforce the default grid
				-- and snap the cursor position to the default grid:
				reset_grid_and_cursor;

				
			when key_noun_unit =>
				noun := NOUN_UNIT;
				set_status (et_canvas_schematic_units.status_drag);

				-- When dragging units, we enforce the default grid
				-- and snap the cursor position to the default grid:
				reset_grid_and_cursor;

				
			-- If space pressed then the operator wishes to operate
			-- by keyboard:
			when key_space =>	
				case noun is
					when NOUN_SEGMENT =>
						-- When dragging net segments, we enforce the default grid
						-- and snap the cursor position to the default grid:
						reset_grid_and_cursor;
						et_canvas_schematic_nets.drag_object (KEYBOARD, get_cursor_position);						

					when NOUN_UNIT =>
						-- When dragging units, we enforce the default grid
						-- and snap the cursor position to the default grid:
						reset_grid_and_cursor;
						et_canvas_schematic_units.drag_object (KEYBOARD, get_cursor_position);

					when others => null;						
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_UNIT =>
						if clarification_pending then
							et_canvas_schematic_units.clarify_object;
						end if;

					when NOUN_SEGMENT =>
						if clarification_pending then
							et_canvas_schematic_nets.clarify_object;
						end if;

					when others => null;						
				end case;

				
			when others => status_noun_invalid;
		end case;
	end drag;


	
	
	procedure draw is 
		use pac_path_and_bend;
	begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_net =>
				noun := NOUN_NET;
				
				set_status (status_draw_net);

				-- we start a new route:
				reset_preliminary_segment;

				-- When drawing net segments, we enforce the default grid
				-- and snap the cursor position to the default grid:
				reset_grid_and_cursor;

				
			-- If space pressed, then the operator wishes to operate via keyboard:
			when key_space =>
				case noun is
					when NOUN_NET =>
						-- When drawing net segments, we enforce the default grid
						-- and snap the cursor position to the default grid:
						reset_grid_and_cursor;

						make_path (KEYBOARD, get_cursor_position);	
						
					when others => null;
				end case;

				
			-- If B pressed, then a bend style is being selected.
			-- this affects only certain modes and is ignored otherwise:
			when key_bend_style =>
				case noun is
					when NOUN_NET =>
						next_bend_style (live_path);
						
					when others => null;
						
				end case;
				
			when others => status_noun_invalid;
		end case;
	end draw;


	
	
	procedure move is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
-- 				when key_noun_net =>
-- 					noun := NOUN_NET;

				-- CS
				--set_status (et_canvas_schematic_nets.status_move);

			when key_noun_label =>
				noun := NOUN_LABEL;
				set_status (et_canvas_schematic_nets.status_move);

			when GDK_LC_n => -- CS
				noun := NOUN_NAME;					
				set_status (et_canvas_schematic_units.status_move);

			when GDK_LC_p => -- CS
				noun := NOUN_PURPOSE;					
				set_status (et_canvas_schematic_units.status_move);
				
			when key_noun_unit =>
				noun := NOUN_UNIT;
				set_status (et_canvas_schematic_units.status_move);

				-- When moving units, we enforce the default grid
				-- and snap the cursor position to the default grid:
				reset_grid_and_cursor;
				
			when GDK_LC_v => -- CS
				noun := NOUN_VALUE;					
				set_status (et_canvas_schematic_units.status_move);

				
			-- If space pressed then the operator wishes to operate
			-- by keyboard:
			when key_space =>	
				case noun is
-- CS
-- 						when NOUN_NET =>
-- 							if not segment.being_moved then
-- 								
-- 								-- Set the tool being used for moving the segment:
-- 								segment.tool := KEYBOARD;
-- 								
-- 								if not clarification_pending then
-- 									find_segments (get_cursor_position);
-- 								else
-- 									segment.being_moved := true;
-- 									reset_request_clarification;
-- 								end if;
-- 								
-- 							else
-- 								-- Finally assign the cursor position to the
-- 								-- currently selected segment:
-- 								et_canvas_schematic_nets.finalize_move (
-- 									destination		=> get_cursor_position,
-- 									log_threshold	=> log_threshold + 1);
-- 
-- 							end if;

					when NOUN_LABEL =>
						et_canvas_schematic_nets.move_object (KEYBOARD, get_cursor_position);
						
					when NOUN_NAME | NOUN_PURPOSE | NOUN_VALUE =>
						et_canvas_schematic_units.move_object (KEYBOARD, get_cursor_position);
						
					when NOUN_UNIT =>
						-- When moving units, we enforce the default grid
						-- and snap the cursor position to the default grid:
						reset_grid_and_cursor;
						et_canvas_schematic_units.move_object (KEYBOARD, point);

					when others => null;
						
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_LABEL => 
						if clarification_pending then
							et_canvas_schematic_nets.clarify_object;
						end if;
					
					when NOUN_NAME | NOUN_PURPOSE | NOUN_VALUE => 
						if clarification_pending then
							et_canvas_schematic_units.clarify_object;
						end if;

					when NOUN_UNIT =>
						if clarification_pending then
							et_canvas_schematic_units.clarify_object;
						end if;
						
					when others => null;
				end case;
				
			when others => status_noun_invalid;
		end case;
	end move;


	
	procedure place is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when GDK_LC_l => -- CS
				noun := NOUN_LABEL;
				-- label.appearance := SIMPLE;
				-- set_status (et_canvas_schematic_nets.status_place_label_simple);

				-- For placing simple net labels, the fine grid is required:
				-- CS self.set_grid (FINE);
				
			when GDK_L => -- CS
				noun := NOUN_LABEL;
				-- label.appearance := TAG;
				-- set_status (et_canvas_schematic_nets.status_place_label_tag);

			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					when NOUN_LABEL =>
						null; -- CS
						-- place_label (KEYBOARD, get_cursor_position);
						
					when others => null;							
				end case;

			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is

					when NOUN_LABEL => 
						if clarification_pending then
							clarify_net_segment;
						end if;

					when others => null;
						
				end case;

			when GDK_LC_r =>
				case noun is

					when NOUN_LABEL =>
						-- Rotate simple label:
						null; -- CS
						-- if label.ready then
						-- 	toggle_rotation (label.rotation_simple);
						-- end if;

					when others => null;
						
				end case;
				
			when others => status_noun_invalid;
		end case;
	end place;


	
	procedure rotate is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when GDK_LC_n => -- CS
				noun := NOUN_NAME;					
				set_status (et_canvas_schematic_units.status_rotate_placeholder);

			when GDK_LC_p => -- CS
				noun := NOUN_PURPOSE;					
				set_status (et_canvas_schematic_units.status_rotate_placeholder);

				
			when key_noun_unit =>
				noun := NOUN_UNIT;					
				set_status (et_canvas_schematic_units.status_rotate);

			when GDK_LC_v => -- CS
				noun := NOUN_VALUE;					
				set_status (et_canvas_schematic_units.status_rotate_placeholder);


			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					when NOUN_NAME =>
						if not clarification_pending then
							rotate_placeholder (
								point		=> get_cursor_position,
								category	=> NAME);
						else
							rotate_selected_placeholder (NAME);
						end if;
						
					when NOUN_PURPOSE =>
						if not clarification_pending then
							rotate_placeholder (
								point		=> get_cursor_position,
								category	=> PURPOSE);
						else
							rotate_selected_placeholder (PURPOSE);
						end if;

					when NOUN_UNIT =>
						et_canvas_schematic_units.rotate_object (point);
						
					when NOUN_VALUE =>
						if not clarification_pending then
							rotate_placeholder (
								point		=> get_cursor_position,
								category	=> VALUE);
						else
							rotate_selected_placeholder (VALUE);
						end if;
						
					when others => null;
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_NAME | NOUN_VALUE | NOUN_PURPOSE => 
						if clarification_pending then
							clarify_placeholder;
						end if;

					when NOUN_UNIT =>
						if clarification_pending then
							et_canvas_schematic_units.clarify_object;
						end if;

					when others => null;
						
				end case;
				
			when others => status_noun_invalid;
		end case;
	end rotate;



	
	procedure add is 
		use pac_devices_lib;
	begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_device =>
				noun := NOUN_DEVICE;					
				set_status (et_canvas_schematic_units.status_add);

				-- When adding units, we enforce the default grid
				-- and snap the cursor position to the default grid:
				reset_grid_and_cursor;
				
				-- open device model selection
				show_model_selection; 

				
			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is

					when NOUN_DEVICE =>
						-- When adding units, we enforce the default grid
						-- and snap the cursor position to the default grid:
						reset_grid_and_cursor;

						-- If no unit has been selected yet, then the device
						-- model selection dialog opens.
						if unit_add.device /= pac_devices_lib.no_element then -- unit selected

							-- If a unit has already been selected, then
							-- it will be dropped at the current cursor position:
							drop_unit (get_cursor_position);

							-- Open the model selection to
							-- select the next unit:
							show_model_selection;
									
						else -- no unit selected yet
							-- Open the model selection to 
							-- select a unit:
							show_model_selection;
						end if;
						
					when others => null;
						
				end case;

				
			when others => null;
		end case;
	end add;


	
	procedure fetch is 
		use pac_devices_lib;
	begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_unit =>
				noun := NOUN_UNIT;					
				set_status (et_canvas_schematic_units.status_fetch);
				

			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is

					when NOUN_UNIT =>
						-- If no device has been selected already, then
						-- set the tool used for fetching.
						if unit_add.device = pac_devices_lib.no_element then

							if not clarification_pending then
								fetch_unit (get_cursor_position);
							else
								show_units;
							end if;

						else
							finalize_fetch (get_cursor_position, log_threshold + 1);
						end if;
						
					when others => null;
						
				end case;
				

			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is

					when NOUN_UNIT => 
						if clarification_pending then
							clarify_unit;
						end if;
						
					when others => null;
						
				end case;
				
			when others => null;
		end case;
	end fetch;

	
	
	procedure set is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when GDK_LC_p =>
				noun := NOUN_PARTCODE;
				set_status (et_canvas_schematic_units.status_set_partcode);

			when GDK_LC_u =>
				noun := NOUN_PURPOSE;
				set_status (et_canvas_schematic_units.status_set_purpose);
			
			when GDK_LC_v =>
				noun := NOUN_VALUE;					
				set_status (et_canvas_schematic_units.status_set_value);

			when GDK_LC_a =>
				noun := NOUN_VARIANT;
				set_status (et_canvas_schematic_units.status_set_variant);
				
			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					
					when NOUN_PARTCODE | NOUN_PURPOSE | NOUN_VALUE | NOUN_VARIANT =>
						if not clarification_pending then
							set_property (get_cursor_position);
						else
							set_property_selected_unit;
						end if;
						
					when others => null;
				end case;

			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_PARTCODE | NOUN_PURPOSE | NOUN_VALUE | NOUN_VARIANT =>
						if clarification_pending then
							clarify_unit;
						end if;

					when others => null;							
				end case;
				
			when others => status_noun_invalid;
		end case;
		
	end set;


	
	procedure show is begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_device =>
				noun := NOUN_DEVICE;
				set_status (et_canvas_schematic_units.status_show_device);
				
			when key_noun_net =>
				noun := NOUN_NET;
				set_status (et_canvas_schematic_nets.status_show_net);

			when GDK_LC_l =>  -- CS
				noun := NOUN_LABEL;
				-- CS set_status (et_canvas_schematic_nets.status_show_label);

				
			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					when NOUN_DEVICE =>
						if not clarification_pending then
							find_units_for_show (get_cursor_position);
						else
							show_properties_of_selected_device;
						end if;


					when NOUN_LABEL =>
						et_canvas_schematic_nets.show_object (get_cursor_position);
						
					when NOUN_NET =>
						et_canvas_schematic_nets.show_object (get_cursor_position);
						
					when others => null;
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_DEVICE => 
						if clarification_pending then
							clarify_unit;
						end if;

					when NOUN_NET | NOUN_LABEL =>
						if clarification_pending then
							et_canvas_schematic_nets.clarify_object;
						end if;

					when others => null;
						
				end case;
				
			when others => status_noun_invalid;
		end case;
	end show;


	
	
	procedure rename is 
		use et_schematic_ops.nets;
	begin
		case key is
			-- EVALUATE KEY FOR NOUN:
			when key_noun_device =>
				noun := NOUN_DEVICE;
				set_status (et_canvas_schematic_units.status_rename);

				
			when key_noun_strand => -- rename strand
				noun := NOUN_NET;
				net_rename.scope := STRAND;
				set_status (et_canvas_schematic_nets.status_rename_net_strand);

				
			when key_noun_net => -- rename all strands on current sheet
				noun := NOUN_NET;
				net_rename.scope := SHEET;
				set_status (et_canvas_schematic_nets.status_rename_net_sheet);

				
			when key_noun_net_all_sheets => -- rename everywhere: all strands on all sheets
				noun := NOUN_NET;
				net_rename.scope := EVERYWHERE;
				set_status (et_canvas_schematic_nets.status_rename_net_everywhere);

				
			-- If space pressed, then the operator wishes to operate via keyboard:	
			when key_space =>
				case noun is
					when NOUN_DEVICE =>
						if not clarification_pending then
							set_property (get_cursor_position);
						else
							set_property_selected_unit;
						end if;

					when NOUN_NET =>
						if not clarification_pending then
							-- CS 
							null;
						else
							et_canvas_schematic_nets.window_set_property;
						end if;
						
					when others => null;
				end case;

				
			-- If page down pressed, then the operator is clarifying:
			when key_clarify =>
				case noun is
					when NOUN_DEVICE =>
						if clarification_pending then
							clarify_unit;
						end if;

					when NOUN_NET =>
						if clarification_pending then
							clarify_net_segment;
						end if;
						
					when others => null;							
				end case;
				
			when others => status_noun_invalid;
		end case;

	end rename;

	
	
begin -- key_pressed
	log (text => "key_pressed (schematic) ", -- CS which key ?
		 level => log_threshold);

-- 		put_line ("schematic: evaluating other key ...");
-- 		put_line (gdk_modifier_type'image (key_ctrl));

	case key is
			
		when others =>

			-- CS: The following block seems not relevant any more and 
			-- thus has been put in comments for the time being:
			
			-- If an imcomplete command has been entered via console then it starts
			-- waiting for finalization. This can be done by pressing the SPACE key.
			-- Then we call the corresponding subprogram for the actual job right away here:
			
			--if single_cmd.finalization_pending and primary_tool = KEYBOARD then
-- 			if finalization_is_pending (cmd) then
-- 			
-- 				if key = key_space then
-- 						
-- 					case verb is
-- 						when VERB_DELETE	=> delete;
-- 						when VERB_DRAG		=> drag;
-- 						when VERB_DRAW		=> draw;
-- 						when VERB_FETCH		=> fetch;
-- 						when VERB_MOVE		=> move;
-- 						when VERB_PLACE		=> place;							
-- 						when others			=> null;
-- 					end case;
-- 
-- 				end if;
-- 			else
			-- Evaluate the verb and noun (as typed on the keyboard):
				
				case expect_entry is
					when EXP_VERB =>
						--put_line ("VERB entered");

						-- Next we expect an entry to select a noun.
						-- If the verb entry is invalid then expect_entry
						-- will be overwritten by EXP_VERB so that the
						-- operator is required to re-enter a valid verb.
						expect_entry := EXP_NOUN;

						-- As long as no valid noun has been entered
						-- display the default noun:
						noun := noun_default;

						-- EVALUATE KEY FOR VERB:
						case key is
							when key_verb_delete =>
								verb := VERB_DELETE;
								status_enter_noun;

							when key_verb_add =>
								verb := VERB_ADD;
								status_enter_noun;
								
							when key_verb_drag =>
								verb := VERB_DRAG;
								status_enter_noun;

							when key_verb_draw =>
								verb := VERB_DRAW;
								status_enter_noun;

							when key_verb_show =>
								verb := VERB_SHOW;
								status_enter_noun;
								
							when key_verb_fetch =>
								verb := VERB_FETCH;
								status_enter_noun;
								
							when key_verb_move =>
								verb := VERB_MOVE;
								status_enter_noun;

							when key_verb_rename =>
								verb := VERB_RENAME;
								status_enter_noun;
								
							when key_verb_place =>
								verb := VERB_PLACE;
								status_enter_noun;
								
							when key_verb_rotate =>
								verb := VERB_ROTATE;
								status_enter_noun;

							when key_verb_set =>
								verb := VERB_SET;
								status_enter_noun;
								
							when others =>
								--put_line ("other key pressed " & gdk_key_type'image (key));
								
								-- If invalid verb entered, overwrite expect_entry by EXP_VERB
								-- and show error in status bar:
								expect_entry := EXP_VERB;
								status_verb_invalid;
						end case;


					when EXP_NOUN =>
						--put_line ("NOUN entered");

						case verb is
							when VERB_ADD		=> add;
							when VERB_DELETE	=> delete;
							when VERB_DRAG		=> drag;
							when VERB_DRAW		=> draw;
							when VERB_FETCH		=> fetch;
							when VERB_MOVE		=> move;
							when VERB_PLACE		=> place;
							when VERB_RENAME	=> rename;
							when VERB_ROTATE	=> rotate;
							when VERB_SET		=> set;
							when VERB_SHOW		=> show;
							when others => null; -- CS
						end case;
						
				end case;

			-- end if;		
	end case;

	redraw;
	-- CS use redraw_schematic if only schematic affected
	-- CS redraw after "enter" pressed
	
	update_mode_display;


	-- CS
	-- exception when event: others =>
	-- 	set_status (exception_message (event));
	-- 	reset_selections;
	-- 	redraw;
	-- 	update_mode_display;
	
end key_pressed;


-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
