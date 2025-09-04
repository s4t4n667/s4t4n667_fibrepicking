return {
    debug = true,

    item = 'fibres', -- item name for what you collect
    
    cooldown = 5000, -- 5 seconds 
    
    picking = {
        minAmount = 1,     
        maxAmount = 5,
        
        animation = 'e mechanic4',

        useSkillcheck = false,
        skillCheck = {'easy', 'easy', 'easy'},
        skillCheckKeys = { 'e', 'e', 'e' },

        progressDuration = 3000, -- only used if useSkillcheck is false 
    },

    sell = {
        ped = `a_m_m_farmer_01`,
        coords = vector4(2588.0945, 4665.3818, 34.0768, 227.5840),
        moneyItem = 'money',
        price = 10,
        currency = "$",
        sellDialog = "Sell Custom Amount",
        customAmount = "Enter Amount: ",
    },

    tool = { -- accepts table of tools or false to disable
        {
            item = 'shears',
            price = 1000,
            icon = 'fa-solid fa-scissors',
        },
    },

    target = {
        label = 'Pick Fibres',
        icon = 'fa-solid fa-hand',
        iconColor = '#76A9D2',
        distance = 2.5,
    },

    blip = {
        enabled = true,
        label = 'Fibre Field',
        coords = vector3(2637.9, 4591.71, 36.7),
        sprite = 846,
        spriteColor = 16,
        scale = 0.8,
    },

}