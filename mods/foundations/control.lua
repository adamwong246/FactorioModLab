local function on_built(event)
    print(serpent.block(some_table))
    print("returning false")
    return false

end

script.on_event(defines.events.on_built_entity, on_built, {})
