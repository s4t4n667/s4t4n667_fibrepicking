return {
    
    blip = {
        enabled = true,
        label = 'Fibre Field',
        coords = vector3(2637.9, 4591.71, 36.7),
        sprite = 846,
        spriteColor = 16,
        scale = 0.8,
    },

    item = 'fibres', -- item name for what you collect
    
    skillCheck = {'easy', 'easy', 'easy'},
    
    amountPicked = 1, -- amount you get every time

    animation = 'e mechanic4', -- emote command

    target = {
        label = 'Pick Fibres',
        icon = 'fa-solid fa-hand',
        iconColor = '#76A9D2',
        distance = 2.5,
    },

}