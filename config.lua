return {
    
    item = 'fibres', -- item name for what you collect/receive
    
    requireGatherItem = true,
    gatherItem = 'shears', -- item name for what you need to be able to start collecting
    
    cooldown = 5000, -- 5 seconds 

    blip = {
        enabled = true,
        label = 'Fibre Field',
        coords = vector3(2637.9, 4591.71, 36.7),
        sprite = 846,
        spriteColor = 16,
        scale = 0.8,
    },

    target = {
        label = 'Pick Fibres',
        icon = 'fa-solid fa-hand',
        iconColor = '',
        distance = 2.5,
    },

    notifications = {
        position = 'top',
        failColor = '#8C2425',
        icon = 'fa-solid fa-wheat-awn',
    },

    shop = {
        enabled = true,
        blip = {
            enabled = true,
            label = 'Fibre Picking Shop',
            sprite = 52,
            spriteColor = 16,
            scale = 0.8
        },
        coords = vector4(2587.6760, 4665.5801, 34.0768, 224.9989),
        pedModel = 'a_m_m_farmer_01',
        items = {
            { type = 'buy', label = 'Shears', item = 'shears', icon = 'fa-scissors',  price = 10 },
            { type = 'buy', label = 'Water', item = 'water', icon = 'fa-bottle-water', iconColor = '', price = 10 },
            { type = 'sell', label = 'Fibres', item = 'fibres', icon = 'fa-seedling', iconColor = '', price = 10 },
        },        
    },
    
    picking = {
        minAmount = 1,     
        maxAmount = 5,
        
        animation = 'e mechanic4',

        useSkillcheck = false,
        skillCheck = {'easy', 'easy', 'easy'},
        skillCheckKeys = { 'e', 'e', 'e' },

        progressDuration = 3000, -- only used if useSkillcheck is false
        progressCanCancel = false, -- whether players can cancel the progressbar
    },

}
