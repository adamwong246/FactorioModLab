-- create a new collision mask which denotes a "foundation". Infer whether it is natural from the autoplace attribute.
------------
local CollisionMaskUtil = require("__core__.lualib.collision-mask-util")
local foundationCollisionMaskLayer = CollisionMaskUtil.get_first_unused_layer()

for _, tile in pairs(data.raw.tile) do
    if tile.autoplace ~= nil then
        table.insert(tile.collision_mask, foundationCollisionMaskLayer);
    end
    data:extend({tile});
end

------------

local heated_pipes_tint = {0.5, 0.4, 0.3, 0.5}
local heat_glow_tint = {1, 1, 1, 1}

local colorIntensity = 0.5;

local baseFlags = {"placeable-player", "player-creation"};

function make_4way_animation_from_spritesheet(animation)
    local function make_animation_layer(idx, anim)
        local start_frame = (anim.frame_count or 1) * idx
        local x = 0
        local y = 0
        if anim.line_length then
            y = anim.height * math.floor(start_frame / (anim.line_length or 1))
        else
            x = idx * anim.width
        end
        return {
            filename = anim.filename,
            priority = anim.priority or "high",
            flags = anim.flags,
            x = x,
            y = y,
            width = anim.width,
            height = anim.height,
            frame_count = anim.frame_count or 1,
            line_length = anim.line_length,
            repeat_count = anim.repeat_count,
            shift = anim.shift,
            draw_as_shadow = anim.draw_as_shadow,
            force_hr_shadow = anim.force_hr_shadow,
            apply_runtime_tint = anim.apply_runtime_tint,
            animation_speed = anim.animation_speed,
            scale = anim.scale or 1,
            tint = anim.tint,
            blend_mode = anim.blend_mode
        }
    end

    local function make_animation_layer_with_hr_version(idx, anim)
        local anim_parameters = make_animation_layer(idx, anim)
        if anim.hr_version and anim.hr_version.filename then
            anim_parameters.hr_version = make_animation_layer(idx, anim.hr_version)
        end
        return anim_parameters
    end

    local function make_animation(idx)
        if animation.layers then
            local tab = {
                layers = {}
            }
            for k, v in ipairs(animation.layers) do
                table.insert(tab.layers, make_animation_layer_with_hr_version(idx, v))
            end
            return tab
        else
            return make_animation_layer_with_hr_version(idx, animation)
        end
    end

    return {
        north = make_animation(0),
        east = make_animation(1),
        south = make_animation(2),
        west = make_animation(3)
    }
end

function apply_heat_pipe_glow(layer)
    layer.tint = heated_pipes_tint
    if layer.hr_version then
        layer.hr_version.tint = heated_pipes_tint
    end
    local light_layer = util.copy(layer)
    light_layer.draw_as_light = true
    light_layer.tint = heat_glow_tint
    if light_layer.hr_version then
        light_layer.hr_version.draw_as_light = true
        light_layer.hr_version.tint = heat_glow_tint
    end
    return {
        layers = {layer, light_layer}
    }
end

function applyTint(entity, tint)
    -- lame styling but it works
    for _, animationLayer in pairs(entity.on_animation.layers) do
        if not animationLayer.draw_as_light and not animationLayer.draw_as_shadow then
            animationLayer.tint = tint;
            animationLayer.apply_runtime_tint = true;
        end
    end
    for _, animationLayer in pairs(entity.off_animation.layers) do
        if not animationLayer.draw_as_light and not animationLayer.draw_as_shadow then
            animationLayer.tint = tint;
            animationLayer.apply_runtime_tint = true;
        end
    end
end

for _ = 0, 5 do

    local labLevel = _ + 1;
    local labName = "lab-" .. tostring(_);

    local newLabEntity = table.deepcopy(data.raw.lab.lab);
    local newLabRecipe = table.deepcopy(data.raw.recipe.lab);
    local newLabItem = table.deepcopy(data.raw.item.lab);

    if _ == 0 then
        -- newLabEntity.description = "hello world";
        newLabEntity.flags = {"placeable-player", "player-creation", "not-repairable", "no-automated-item-insertion"};
    else

        newLabEntity.flags = {"placeable-player", "player-creation"};

        newLabEntity.name = labName;
        newLabRecipe.name = labName;
        newLabRecipe.result = labName;
        newLabItem.name = labName;
        newLabItem.place_result = labName;

        -- all labs+ are 10x by default, tho these might be overwritten below
        newLabEntity.researching_speed = 10;
        newLabRecipe.energy_required = (10 * labLevel) * newLabRecipe.energy_required;
        newLabEntity.energy_usage = (10 * labLevel) .. "kW"
        newLabEntity.energy_source.emissions_per_minute = (10 * labLevel);

        if _ == 1 then -- chemical
            newLabEntity.minable = nil;
            newLabEntity.collision_mask = {foundationCollisionMaskLayer, "item-layer", "object-layer", "player-layer",
                                           "water-tile"};

            applyTint(newLabEntity, {colorIntensity, 0, 0, 1});
            newLabEntity.energy_source = {
                type = "burner",
                fuel_category = "chemical",
                effectivity = 1,
                fuel_inventory_size = 1,
                emissions_per_minute = 2,
                light_flicker = {
                    color = {1, 0, 0},
                    minimum_intensity = 0.1,
                    maximum_intensity = 0.9
                },
                smoke = {{
                    name = "smoke",
                    deviation = {0.1, 0.1},
                    frequency = 5,
                    position = {0.0, -0.8},
                    starting_vertical_speed = 0.08,
                    starting_frame_deviation = 60
                }}
            };

        elseif _ == 2 then -- nuclear
            newLabEntity.minable = nil;
            applyTint(newLabEntity, {0, colorIntensity, 0, 1});
            newLabEntity.collision_mask = {foundationCollisionMaskLayer, "item-layer", "object-layer", "player-layer",
                                           "water-tile"};

            newLabEntity.energy_source = {
                type = "burner",
                fuel_category = "nuclear",
                effectivity = 1,
                fuel_inventory_size = 1,
                emissions_per_minute = 2,
                light_flicker = {
                    -- color = {0, 1, 0},
                    minimum_intensity = 0.1,
                    maximum_intensity = 0.9
                }
            };

        elseif _ == 3 then -- heat
            newLabEntity.minable = nil;
            applyTint(newLabEntity, {1, colorIntensity, 0, 1});
            newLabEntity.collision_mask = {foundationCollisionMaskLayer, "item-layer", "object-layer", "player-layer",
                                           "water-tile"};
            newLabEntity.max_health = 1000;
            newLabEntity.energy_source = {
                type = "heat",
                max_temperature = 1000,
                specific_heat = "1MJ",
                max_transfer = "2GW",
                min_working_temperature = 500,
                minimum_glow_temperature = 350,
                connections = {{
                    position = {0, 0.5},
                    direction = defines.direction.south
                }},
                pipe_covers = make_4way_animation_from_spritesheet({
                    filename = "__base__/graphics/entity/heat-exchanger/heatex-endings.png",
                    width = 32,
                    height = 32,
                    direction_count = 4,
                    hr_version = {
                        filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-endings.png",
                        width = 64,
                        height = 64,
                        direction_count = 4,
                        scale = 0.5
                    }
                }),
                heat_pipe_covers = make_4way_animation_from_spritesheet(apply_heat_pipe_glow {
                    filename = "__base__/graphics/entity/heat-exchanger/heatex-endings-heated.png",
                    width = 32,
                    height = 32,
                    direction_count = 4,
                    hr_version = {
                        filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-endings-heated.png",
                        width = 64,
                        height = 64,
                        direction_count = 4,
                        scale = 0.5
                    }
                }),
                heat_picture = {
                    north = apply_heat_pipe_glow {
                        filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
                        priority = "extra-high",
                        width = 24,
                        height = 48,
                        shift = util.by_pixel(-1, 8),
                        hr_version = {
                            filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-N-heated.png",
                            priority = "extra-high",
                            width = 44,
                            height = 96,
                            shift = util.by_pixel(-0.5, 8.5),
                            scale = 0.5
                        }
                    },
                    east = apply_heat_pipe_glow {
                        filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
                        priority = "extra-high",
                        width = 40,
                        height = 40,
                        shift = util.by_pixel(-21, -13),
                        hr_version = {
                            filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-E-heated.png",
                            priority = "extra-high",
                            width = 80,
                            height = 80,
                            shift = util.by_pixel(-21, -13),
                            scale = 0.5
                        }
                    },
                    south = apply_heat_pipe_glow {
                        filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
                        priority = "extra-high",
                        width = 16,
                        height = 20,
                        shift = util.by_pixel(-1, -30),
                        hr_version = {
                            filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-S-heated.png",
                            priority = "extra-high",
                            width = 28,
                            height = 40,
                            shift = util.by_pixel(-1, -30),
                            scale = 0.5
                        }
                    },
                    west = apply_heat_pipe_glow {
                        filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
                        priority = "extra-high",
                        width = 32,
                        height = 40,
                        shift = util.by_pixel(23, -13),
                        hr_version = {
                            filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-W-heated.png",
                            priority = "extra-high",
                            width = 64,
                            height = 76,
                            shift = util.by_pixel(23, -13),
                            scale = 0.5
                        }
                    }
                }
            };

        elseif _ == 4 then -- petro
            newLabEntity.minable = nil;
            newLabEntity.collision_mask = {foundationCollisionMaskLayer, "item-layer", "object-layer", "player-layer",
                                           "water-tile"};
            applyTint(newLabEntity, {colorIntensity, colorIntensity, colorIntensity, 1});
        elseif _ == 5 then -- electro
            applyTint(newLabEntity, {1, 1, 1, 0.5});
            newLabEntity.max_health = 1;
        end

    end

    data:extend({newLabEntity, newLabRecipe, newLabItem});

end
