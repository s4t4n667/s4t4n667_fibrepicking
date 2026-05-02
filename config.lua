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
        position = 'top-right',
        failColor = '#8C2425',
        icon = 'fa-solid fa-wheat-awn',
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
