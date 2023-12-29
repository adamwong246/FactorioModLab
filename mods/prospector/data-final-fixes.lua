local resource_autoplace = require('resource-autoplace');
require("constructions");

local plain = "basic-solid";
-- local deep = "basic-solid-deep";
-- local deeper = "basic-solid-deeper";
local earth = "earth";
local silver = "silver";
local gold = "gold";

-- local deepDrill = "deep drill";

-- local deepResourceCategory = table.deepcopy(data.raw["resource-category"][plain]);
-- deepResourceCategory.name = deep;
-- local deeperResourceCategory = table.deepcopy(data.raw["resource-category"][plain]);
-- deeperResourceCategory.name = deeper;

-- local deepElectricMiningDrill = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"]);
-- deepElectricMiningDrill.name = deepDrill;
-- deepElectricMiningDrill.resource_categories = {plain, deep};

-- local deeperDrill = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"]);
-- deeperDrill.resource_categories = {plain, deep, deeper};
-- deeperDrill.name = "deeper drill";

-- local deepDrillRecipe = table.deepcopy(data.raw.recipe["electric-mining-drill"]);
-- deepDrillRecipe.normal.result = deepDrill;
-- deepDrillRecipe.expensive.result = deepDrill;
-- local deeperDrillRecipe = table.deepcopy(data.raw.recipe["electric-mining-drill"]);
-- deeperDrillRecipe.normal.result = deeperDrillRecipe.name;
-- deeperDrillRecipe.expensive.result = deeperDrillRecipe.name;

local earthResource = table.deepcopy(data.raw["resource"]["stone"]);
earthResource.name = "earth";
earthResource.minable.result = nil;
earthResource.infinite = true;
earthResource.minimum = 1;
earthResource.minable.results = {{
    name = "earth",
    probability = 0.9,
    amount = 1
}, {
    name = "stone",
    probability = 0.09,
    amount = 1
}, {
    name = "silver",
    probability = 0.009,
    amount = 1
}, {
    name = "gold",
    probability = 0.001,
    amount = 1
}};
earthResource.autoplace = nil;
-- earthResource.category = deep;
-- earthResource.highlight = false;
-- earthResource.map_grid = false;
-- earthResource.map_color = {0, 0, 0, 0};
-- earthResource.map_color = {1, 1, 1, 1};

-- earthResource.resource_patch_search_radius = false
earthResource.selectable_in_game = false;
earthResource.stages.sheet.tint = {0, 0, 0, 0};
earthResource.stages.sheet.hr_version.tint = {0, 0, 0, 0};

local earthItem = table.deepcopy(data.raw["item"]["stone"]);
earthItem.name = earth;
earthItem.tint = {
    r = 1,
    g = 0,
    b = 0,
    a = 1
};

-- local earthAutoplace = table.deepcopy(data.raw["autoplace-control"]["stone"]);
-- earthAutoplace.name = earth;
-- earthAutoplace.localised_name = {"", "[entity=earth] ", {"entity-name.earth"}};
-- earthAutoplace.order = "b-x";

local silverResource = table.deepcopy(data.raw["resource"]["copper-ore"]);
silverResource.map_color = {0, 0, 0, 0};
silverResource.name = silver;
silverResource.highlight = false;
silverResource.autoplace = resource_autoplace.resource_autoplace_settings({
    name = "silver",
    order = "b-y",
    base_density = 33,
    has_starting_area_placement = true,
    regular_rq_factor_multiplier = 0.8
});
-- silverResource.autoplace.name = silver;
-- silverResource.autoplace.autoplace_control_name = silver;
silverResource.minable.result = silver;
silverResource.selectable_in_game = false;
-- silverResource.category = deep;

local silverItem = table.deepcopy(data.raw["item"]["copper-ore"]);
silverItem.name = silver;

local silverAutoplace = table.deepcopy(data.raw["autoplace-control"]["copper-ore"]);
silverAutoplace.name = silver;
silverAutoplace.localised_name = {"", "[entity=silver] ", {"entity-name.silver"}};
silverAutoplace.order = "c-a";

local goldResource = table.deepcopy(data.raw["resource"]["copper-ore"]);
goldResource.name = gold;
goldResource.map_color = {0, 0, 0, 0};
goldResource.selectable_in_game = false;
goldResource.highlight = false;
goldResource.minable.result = gold;
goldResource.autoplace = resource_autoplace.resource_autoplace_settings({
    name = gold,
    order = "b-z",
    base_density = 33,
    has_starting_area_placement = true,
    regular_rq_factor_multiplier = 0.8
});
-- goldResource.category = deep;

local goldItem = table.deepcopy(data.raw["item"]["copper-ore"]);
goldItem.name = gold;

local goldAutoplace = table.deepcopy(data.raw["autoplace-control"]["copper-ore"]);
goldAutoplace.name = gold;
goldAutoplace.localised_name = {"", "[entity=gold] ", {"entity-name.gold"}};
goldAutoplace.order = "c-b";

data:extend({ -- deepElectricMiningDrillItem, deepResourceCategory, deepElectricMiningDrill, deepDrillRecipe,
-- deeperResourceCategory, deeperDrill, deeperDrillRecipe,
-- emdRecipe, constructionCategory, emdConstructionItem, emdConstructionRecipe, emdConstructionEntity, 
earthItem, earthResource, silverResource, silverItem, silverAutoplace, goldResource, goldItem, goldAutoplace});

local boringColor = {1, 1, 1, 1};

for _, resource in pairs(data.raw.resource) do
    resource.highlight = false;
    resource.map_grid = false;
    resource.resource_patch_search_radius = false
    resource.selectable_in_game = false;
    -- resource.selection_box = {{0, 0}, {0, 0}}
    -- resource.minable = nil

    local oreSheet = resource.stages.sheet
    -- resource.map_color = boringColor;

    if (resource.name == "earth") then
        resource.map_color = {0, 0, 0, 0}; -- invisible
        resource.highlight = false;
        resource.map_grid = false;
        resource.resource_patch_search_radius = false
        resource.selectable_in_game = false;

    elseif (resource.name == "stone" or resource.name == "coal") then
        -- resource.highlight = false;
        -- resource.map_grid = false;
        
        -- resource.resource_patch_search_radius = false
        -- resource.selectable_in_game = true;
    else
        -- resource.highlight = false;
        -- resource.map_grid = false;
        -- resource.map_color = {0, 0, 0, 0};
        -- resource.resource_patch_search_radius = false
        -- resource.selectable_in_game = false;

    end

    if (resource.name ~= "stone" and resource.name ~= "coal") then
        oreSheet.tint = {0, 0, 0, 0};
        oreSheet.hr_version.tint = {0, 0, 0, 0};
        resource.selectable_in_game = false;
    end

    if (resource.name == "iron-ore" or resource.name == "copper-ore") then
        oreSheet.tint = {0, 0, 0, 0};
        oreSheet.hr_version.tint = {0, 0, 0, 0};
        resource.selectable_in_game = true;
    end

    -- if (resource.name == "copper-ore" or resource.name == "iron-ore") then
    --     resource.category = deep;
    -- end

    -- if (resource.name == "silver") then
    --     resource.category = deep;
    -- elseif resource.name == "gold" then
    --     resource.category = deeper;
    -- end

    data:extend({resource});
end
