-- get list of all science packs
-- get recipes of previous packs
--   - logistics = automation
--   - military = automation, logistics
--   - blue = automation, logistics
-- make some obscene combination of ingredients
-- add recursion resource ?
-- ?
-- profit!
local science_production_modifier = 2 ^ (1 / 3)

local science_packs_accepted_by_labs = {}
for _, v in pairs(data.raw.lab) do
    for _, j in pairs(v.inputs) do
        science_packs_accepted_by_labs[j] = {
            recipes = {},
            technology_unlocks = {}
        }
    end
end

-- get producing recipes
for k, v in pairs(data.raw.recipe) do
    if science_packs_accepted_by_labs[v.result] then
        science_packs_accepted_by_labs[v.result].recipes[k] = table.deepcopy(data.raw.recipe[k])
    end
    if v.results then
        for i, j in pairs(v.results) do
            if science_packs_accepted_by_labs[j.name] then
                science_packs_accepted_by_labs[j.recipe].recipes[k] = table.deepcopy(data.raw.recipe[k])
            end
        end
    end
end

-- get unlocking technologies
for k, v in pairs(data.raw.technology) do
    if v.effects then
        for _, j in pairs(v.effects) do
            if j.type == 'unlock-recipe' then
                if science_packs_accepted_by_labs[j.recipe] then
                    science_packs_accepted_by_labs[j.recipe].technology_unlocks[k] = table.deepcopy(
                        data.raw.technology[k])
                end
            end
        end
    end
end

local scienceLevels = {};

-- adjust recipes
for k, v in pairs(science_packs_accepted_by_labs) do

    local numberOfTechs = table_size(v.technology_unlocks);

    -- if not scienceLevels[numberOfTechs] then
    --     scienceLevels[numberOfTechs] = {};
    -- end

    log(numberOfTechs)
    if numberOfTechs > 0 then

        local techs = {};
        for _, tech in pairs(v.technology_unlocks) do            
            log(serpent.block(tech))
            table.insert(techs, tech);
        end
        table.insert(scienceLevels, numberOfTechs, techs)

        for _, j in pairs(v.technology_unlocks) do
            if j.unit ~= nil and j.unit.ingredients ~= nil then
                for _, m in pairs(j.unit.ingredients) do
                    for n, o in pairs(science_packs_accepted_by_labs[k].recipes) do
                        if o.ingredients ~= nil then
                            local found = false
                            for p, q in pairs(o.ingredients) do
                                if m[1] == q[1] then
                                    found = true
                                    science_packs_accepted_by_labs[k].recipes[n].ingredients[p][2] = q[2] + m[2]
                                    if o.result_count then
                                        if o.result_count * science_production_modifier < 2 then
                                            science_packs_accepted_by_labs[k].recipes[n].result_count = 2
                                        elseif o.result_count * science_production_modifier < 65535 then
                                            science_packs_accepted_by_labs[k].recipes[n].result_count = o.result_count *
                                                                                                            science_production_modifier
                                        elseif o.result_count * science_production_modifier > 65535 then
                                            science_packs_accepted_by_labs[k].recipes[n].result_count = 65534
                                        end
                                    else
                                        science_packs_accepted_by_labs[k].recipes[n].result_count = 2
                                    end
                                    break
                                end
                            end
                            if not found then
                                table.insert(science_packs_accepted_by_labs[k].recipes[n].ingredients, table.deepcopy(m))
                                if o.result_count then
                                    if o.result_count * science_production_modifier < 2 then
                                        science_packs_accepted_by_labs[k].recipes[n].result_count = 2
                                    elseif o.result_count * science_production_modifier < 65535 then
                                        science_packs_accepted_by_labs[k].recipes[n].result_count = o.result_count *
                                                                                                        science_production_modifier
                                    elseif o.result_count * science_production_modifier > 65535 then
                                        science_packs_accepted_by_labs[k].recipes[n].result_count = 65534
                                    end
                                else
                                    science_packs_accepted_by_labs[k].recipes[n].result_count = 2
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        -- no unlocks, skipping for now
        -- log('No Unlocking Technology, removing ' .. k)
        science_packs_accepted_by_labs[k] = nil

    end
end

local recipes_to_extend = {}
for _, v in pairs(science_packs_accepted_by_labs) do
    for _, j in pairs(v.recipes) do
        table.insert(recipes_to_extend, j)
    end
end

data:extend(recipes_to_extend)


-- log(serpent.block(scienceLevels));


-- Copy the base lab definitions and then trash the originals
-- local baseLabEntity = table.deepcopy(data.raw.lab.lab);
-- local baseLabRecipe = table.deepcopy(data.raw.recipe.lab);
-- local baseLabItem = table.deepcopy(data.raw.item.lab);
-- data.raw.lab.lab = nil;
-- data.raw.recipe.lab = nil;
-- data.raw.item.lab = nil;

local newLabs = {};
for _ = 0, table_size(scienceLevels) do

    local labLevel = _ + 1;
    local labName = "Lab" .. tostring(labLevel);
    local newLabEntity = table.deepcopy(data.raw.lab.lab);
    newLabEntity.name = labName;

    local newLabRecipe = table.deepcopy(data.raw.recipe.lab);
    newLabRecipe.name = labName;
    newLabRecipe.result = labName;
    local newLabItem = table.deepcopy(data.raw.item.lab);
    newLabItem.name = labName;
    newLabItem.place_result = labName;
    newLabItem.order = "g[" .. labName .. "]";

    newLabRecipe.energy_required = (10 * labLevel) * newLabRecipe.energy_required;
    newLabEntity.researching_speed = labLevel;
    newLabEntity.energy_usage = (10 * labLevel) .. "kW";
    newLabEntity.energy_source.emissions_per_minute = (10 * labLevel);


    newLabEntity.inputs = {};
    if (_ > 0) then
        -- local memoOfSciencePacks = {};

        for _prev = 1, labLevel - 1 do
            table.insert(newLabRecipe.ingredients, {"Lab" .. tostring(_prev), labLevel - _});
            -- table.insert(newLabRecipe.inputs, scienceLevels[_prev]);

            -- table.insert(memoOfSciencePacks, scienceLevels[_prev]);

            -- newLabRecipe.ingredients["Lab " .. tostring(_prev)] = labLevel - _;
            -- local k = ;
            -- local newIngredients = ;

            -- each tier of lab requires previous tiers of labs
            -- for labNdx, lab in pairs(science_packs_accepted_by_labs[_prev]) do
            --     newLabRecipe.ingredients[lab] = labLevel - labNdx;
            -- end

            -- each tier of lab unlocks labs with wider inputs
            for tndx, tierOfTech in ipairs(scienceLevels[_prev]) do
                -- log(tndx);
                -- log(serpent.block(tierOfTech));

                -- for sciNdx, science in pairs(tierOfTech) do
                --     -- log(serpent.block(science));
                --     table.insert(newLabEntity.inputs, science.name);
                -- end
            end

        end

    end

    log(serpent.block(newLabEntity.inputs))

    newLabs[_] = {
        entity = newLabEntity,
        recipe = newLabRecipe,
        item = newLabItem
    }

end

-- log(serpent.block(newLabs))

for _, lab in pairs(newLabs) do

    data:extend({lab.entity, lab.recipe, lab.item})
end
