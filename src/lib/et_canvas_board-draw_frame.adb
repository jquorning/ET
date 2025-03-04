------------------------------------------------------------------------------
--                                                                          --
--                              SYSTEM ET                                   --
--                                                                          --
--                           BOARD DRAW FRAME                               --
--                                                                          --
--                               B o d y                                    --
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

with ada.text_io;				use ada.text_io;
with ada.characters.handling;	use ada.characters.handling;
with et_text;
with et_meta;

separate (et_canvas_board)

procedure draw_frame (
	self	: not null access type_view)
is
	use et_frames;
	
	frame_size   : et_frames.type_frame_size renames self.get_frame.size;
	frame_height : et_frames.type_distance renames self.get_frame.size.y;
	title_block_position : et_frames.type_position renames self.get_frame.title_block_pcb.position;

	
	procedure draw_cam_markers is
		cms : constant type_cam_markers := self.get_frame.title_block_pcb.cam_markers;

		use et_text;
		use et_display;
		use et_display.board;

		-- These flags indicate whether a top or bottom layer is shown.
		-- If none of them is true, no cam marker for face and no face itself
		-- will be displayed at all.
		top_enabled, bottom_enabled : boolean := false;

		
		procedure evaluate_face is begin

			-- Draw the CAM marker "FACE:" or "SIDE:" if a top or bottom layers is enabled.
			if top_enabled or bottom_enabled then
				draw_text (
					content	=> to_content (to_string (cms.face.content)), -- "FACE:" or "SIDE:"
					size	=> cms.face.size,
					font	=> font_placeholders,
					pos		=> cms.face.position,
					tb_pos	=> title_block_position);

				-- Draw the face like "TOP" or "BOTTOM":
				if top_enabled and bottom_enabled then
					draw_text (
						content	=> to_content (type_face'image (TOP) & " & " & type_face'image (BOTTOM)), -- "TOP & BOTTOM"
						size	=> self.get_frame.title_block_pcb.additional_placeholders.face.size, -- CS use renames
						font	=> font_placeholders,
						pos		=> self.get_frame.title_block_pcb.additional_placeholders.face.position,
						tb_pos	=> title_block_position);

					
				elsif top_enabled then
						draw_text (
							content	=> to_content (type_face'image (TOP)), -- "TOP"
							size	=> self.get_frame.title_block_pcb.additional_placeholders.face.size,
							font	=> font_placeholders,
							pos		=> self.get_frame.title_block_pcb.additional_placeholders.face.position,
							tb_pos	=> title_block_position);
							

				elsif bottom_enabled then
						draw_text (
							content	=> to_content (type_face'image (BOTTOM)), -- "BOTTOM"
							size	=> self.get_frame.title_block_pcb.additional_placeholders.face.size,
							font	=> font_placeholders,
							pos		=> self.get_frame.title_block_pcb.additional_placeholders.face.position,
							tb_pos	=> title_block_position);
							
				end if;
			end if;
		end evaluate_face;

		
		procedure silkscreen is begin
			draw_text (
				content	=> to_content (to_string (cms.silk_screen.content)),
				size	=> cms.silk_screen.size,
				font	=> font_placeholders,
				pos		=> cms.silk_screen.position,
				tb_pos	=> title_block_position);				
		end silkscreen;
			

		procedure assy_doc is begin
			draw_text (
				content	=> to_content (to_string (cms.assy_doc.content)),
				size	=> cms.assy_doc.size,
				font	=> font_placeholders,
				pos		=> cms.assy_doc.position,
				tb_pos	=> title_block_position);				
		end assy_doc;

		
		procedure keepout is begin
			draw_text (
				content	=> to_content (to_string (cms.keepout.content)),
				size	=> cms.keepout.size,
				font	=> font_placeholders,
				pos		=> cms.keepout.position,
				tb_pos	=> title_block_position);				
		end keepout;

		
		procedure stop_mask is begin
			draw_text (
				content	=> to_content (to_string (cms.stop_mask.content)),
				size	=> cms.stop_mask.size,
				font	=> font_placeholders,
				pos		=> cms.stop_mask.position,
				tb_pos	=> title_block_position);				
		end stop_mask;

		
		procedure stencil is begin
			draw_text (
				content	=> to_content (to_string (cms.stencil.content)),
				size	=> cms.stencil.size,
				font	=> font_placeholders,
				pos		=> cms.stencil.position,
				tb_pos	=> title_block_position);
		end stencil;

		
	begin -- draw_cam_markers

		-- silkscreen
		if silkscreen_enabled (TOP) then
			silkscreen;
			top_enabled := true;
		end if;

		if silkscreen_enabled (BOTTOM) then
			silkscreen;
			bottom_enabled := true;
		end if;

		-- assy doc
		if assy_doc_enabled (TOP) then
			assy_doc;
			top_enabled := true;
		end if;
		
		if assy_doc_enabled (BOTTOM) then
			assy_doc;
			bottom_enabled := true;
		end if;

		-- keepout
		if keepout_enabled (TOP) then
			keepout;
			top_enabled := true;
		end if;

		if keepout_enabled (BOTTOM) then
			keepout;
			bottom_enabled := true;
		end if;

		-- plated millings
		if plated_millings_enabled then
			draw_text (
				content	=> to_content (to_string (cms.plated_millings.content)),
				size	=> cms.plated_millings.size,
				font	=> font_placeholders,
				pos		=> cms.plated_millings.position,
				tb_pos	=> title_block_position);	
		end if;

		-- outline
		if outline_enabled then
			draw_text (
				content	=> to_content (to_string (cms.pcb_outline.content)),
				size	=> cms.pcb_outline.size,
				font	=> font_placeholders,
				pos		=> cms.pcb_outline.position,
				tb_pos	=> title_block_position);
		end if;

		-- stop mask
		if stop_mask_enabled (TOP) then
			stop_mask;
			top_enabled := true;
		end if;
	
		if stop_mask_enabled (BOTTOM) then
			stop_mask;
			bottom_enabled := true;
		end if;

		-- stencil
		if stencil_enabled (TOP) then
			stencil;
			top_enabled := true;
		end if;

		if stencil_enabled (BOTTOM) then
			stencil;
			bottom_enabled := true;
		end if;
		
		-- route restrict
		if route_restrict_enabled then
			draw_text (
				content	=> to_content (to_string (cms.route_restrict.content)),
				size	=> cms.route_restrict.size,
				font	=> font_placeholders,
				pos		=> cms.route_restrict.position,
				tb_pos	=> title_block_position);	
		end if;

		-- via restrict
		if via_restrict_enabled then
			draw_text (
				content	=> to_content (to_string (cms.via_restrict.content)),
				size	=> cms.via_restrict.size,
				font	=> font_placeholders,
				pos		=> cms.via_restrict.position,
				tb_pos	=> title_block_position);				
		end if;

		-- conductor layers
		if conductors_enabled then
			draw_text (
				content	=> to_content (to_string (cms.signal_layer.content)), -- "SGNL_LYR:"
				size	=> cms.signal_layer.size,
				font	=> font_placeholders,
				pos		=> cms.signal_layer.position,
				tb_pos	=> title_block_position);				

			draw_text (
				content	=> to_content (enabled_conductor_layers), -- "1,2,5..32"
				size	=> self.get_frame.title_block_pcb.additional_placeholders.signal_layer.size,
				font	=> font_placeholders,
				pos		=> self.get_frame.title_block_pcb.additional_placeholders.signal_layer.position,
				tb_pos	=> title_block_position);				
		end if;

		evaluate_face;
		
	end draw_cam_markers;
	
	
begin -- draw_frame
--		put_line ("draw frame ...");

	if (area = no_area)
		or else intersects (area, self.frame_bounding_box) 
	then
		-- CS test size 
-- 			if not size_above_threshold (self, context.view) then
-- 				return;
-- 			end if;

		
		cairo.set_line_width (context.cr, line_width_thin);

		set_color_frame (context.cr);

		
		-- frame border
		draw_border (
			frame_size		=> frame_size,
			border_width	=> self.get_frame.border_width);

		-- title block lines
		--pac_lines.iterate (self.get_frame.title_block_pcb.lines, query_line'access);

		draw_title_block_lines (
			lines		=> self.get_frame.title_block_pcb.lines,
			tb_pos		=> title_block_position);
		
		-- draw the sector delimiters
		draw_sector_delimiters (
			sectors			=> self.get_frame.sectors,
			frame_size		=> frame_size,
			border_width	=> self.get_frame.border_width);

		-- draw common placeholders and other texts
		draw_texts (
			ph_common	=> self.get_frame.title_block_pcb.placeholders,
			ph_basic	=> type_placeholders_basic (self.get_frame.title_block_pcb.additional_placeholders),
			texts		=> self.get_frame.title_block_pcb.texts,
			meta		=> et_meta.type_basic (element (current_active_module).meta.board),
			tb_pos		=> title_block_position);

		draw_cam_markers;
		
	end if;
	
end draw_frame;


-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
