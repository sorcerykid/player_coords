--------------------------------------------------------
-- Minetest :: Player Coords Mod (player_coords)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2020, Leslie E. Krause
--
-- ./games/minetest_game/mods/player_coords/init.lua
--------------------------------------------------------

local track_player
local log_file
local last_pos
local last_dir

minetest.register_on_joinplayer( function ( player )
	local player_name = player:get_player_name( )

	if player_name == "singleplayer" or minetest.check_player_privs( player_name, "server" ) then
	        log_file = io.open( minetest.get_worldpath( ) .. "/coords.txt", "w" )

        	if log_file then
	                track_player = player
                	last_pos = player:get_pos( )
        	        last_dir = vector.new( )
		end
        end
end )

minetest.register_on_leaveplayer( function ( player )
        if log_file then
		log_file:close( )
		track_player = nil
	end
end )

minetest.register_on_shutdown( function ( )
        if log_file then log_file:close( ) end
end )

minetest.register_globalstep( function( dtime )
        if track_player then
                local pos = track_player:get_pos( )
                local dir = vector.direction( last_pos, pos )

                if math.abs( last_dir.x - dir.x ) > 0.1 or math.abs( last_dir.y - dir.y ) > 0.1 or math.abs( last_dir.z - dir.z ) > 0.1 then
                        log_file:write( minetest.pos_to_string( last_pos ) .. "\n" )
			log_file:flush( )
                        last_dir = dir
                end

                last_pos = pos
        end
end )
