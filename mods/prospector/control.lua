function sensorsOverTiles(event)
    local p = game.players[event.player_index]
    if not p.character then
        return
    end

    if p.walking_state.walking then
        local nearbyResources = p.surface.count_entities_filtered({
            position = p.position,
            name = {"iron-ore", "copper-ore", "silver", "gold"},
            radius = 3
        });

        if (nearbyResources > 0) then
            p.play_sound {
                path = "sensorBeep-high"
            }
        end
    end

end

script.on_event(defines.events.on_player_changed_position, sensorsOverTiles)

-- Iterate over every tile in the new chunk and spam with random resources, if empty and possible.
script.on_event(defines.events.on_chunk_generated, function(event)

    for x = event.area.left_top.x + 0, event.area.right_bottom.x - 1 do
        for y = event.area.left_top.y + 0, event.area.right_bottom.y - 1 do

            local noResources = event.surface.count_entities_filtered({
                position = {x, y},
                radius = 1,
                type = "resource",
                limit = 1
            }) == 0
            if noResources then
                event.surface.create_entity({
                    name = "earth",
                    amount = 1,
                    position = {x, y}
                })
            end

        end
    end
end)

-- script.on_event(defines.events.on_sector_scanned, function(event)
--     local radar = event.radar;
--     local surface = radar.surface;
--     local area = event.area;

--     log(serpent.block(area))

--     local stuff = surface.find_entities_filtered {
--         area = area,
--         type = "resource"
--     }

--     log(serpent.block(stuff))

--     local control = radar.get_control_behavior()

--     log(serpent.block(control))

--     -- control.set_signal(1, {
--     --     count = 2,
--     --     signal = {
--     --         type = "virtual-signal",
--     --         name = "signal-red"
--     --     }
--     -- })

-- end)
-- script.on_event(defines.events.on_chunk_generated, function(event)

--     -- Only one API call
--     local resources = event.surface.find_entities_filtered({
--         area = event.area,
--         type = "resource"
--     })

--     -- Find all tiles covered by resources
--     local tiles = {}
--     for _, resource in pairs(resources) do
--         local pos = resource.position
--         local box = resource.prototype.collision_box
--         -- Big resources cover several tiles
--         for x = math.floor(pos.x + box.left_top.x), math.floor(pos.x + box.right_bottom.x) do
--             for y = math.floor(pos.y + box.left_top.y), math.floor(pos.y + box.right_bottom.y) do
--                 -- Store tile x,y as table key for fast lookup
--                 tiles[x .. "," .. y] = true
--             end
--         end
--     end

--     for x = event.area.left_top.x + 0, event.area.right_bottom.x - 1 do
--         for y = event.area.left_top.y + 0, event.area.right_bottom.y - 1 do

--             -- Check for colliding resource at this x,y
--             if not tiles[x .. "," .. y] then
--                 event.surface.create_entity({
--                     name = "earth",
--                     amount = 1,
--                     position = {x, y}
--                 })
--             end

--         end
--     end

-- end)
