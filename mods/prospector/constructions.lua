local construction = "construction";

local function constructorate(name)
    local constructionSiteNameString = name .. "-construction-site";
    local stage0 = constructionSiteNameString .. "-0";

    data:extend({{
        type = "recipe-category",
        name = stage0
    }, {
        type = "recipe",
        name = stage0,
        icons = data.raw.recipe[name].icons,
        order = "r-s",
        enabled = false,
        energy_required = 100,
        ingredients = {},
        results = {{
            type = "item",
            name = stage0,
            amount = 1
        }}
    }})

end

-- constructorate("electric-mining-drill");

-- local emdRecipe = table.deepcopy(data.raw.recipe["electric-mining-drill"]);
-- -- emdRecipe.hidden = true;
-- -- emdRecipe.enabled = true;
-- emdRecipe.category = construction;

-- local emdConstructionRecipe = table.deepcopy(data.raw.recipe["electric-mining-drill"]);
-- emdConstructionRecipe.name = "emdConstruction";
-- -- emdConstructionRecipe.hidden = false;
-- -- emdConstructionRecipe.enabled = true;
-- emdConstructionRecipe.normal.result = "emdConstruction";
-- emdConstructionRecipe.expensive.result = "emdConstruction";

-- local emdConstructionEntity = table.deepcopy(data.raw["furnace"]["electric-furnace"]);
-- emdConstructionEntity.name = "emdConstruction";
-- emdConstructionEntity.result_inventory_size = 1;
-- -- emdConstructionEntity.fixed_recipe = "electric-mining-drill";
-- emdConstructionEntity.crafting_speed = 1;
-- emdConstructionEntity.crafting_categories = {construction};
-- emdConstructionEntity.module_specification = {
--     module_slots = 0
-- };

-- -- emdConstructionEntity.name = "emdConstruction";
-- -- emdConstructionEntity.place_result = "emdConstruction";

-- local constructionCategory = {
--     type = "recipe-category",
--     name = construction
-- };

-- local emdConstructionItem = table.deepcopy(data.raw["item"]["electric-mining-drill"]);
-- emdConstructionItem.name = "emdConstruction";
-- emdConstructionItem.place_result = "emdConstruction";

-- data:extend({emdRecipe, constructionCategory, emdConstructionItem, emdConstructionRecipe, emdConstructionEntity});
