# s4t4n667_fibrepicking
## Gather fibres from across the city 🚜🧵

Useful resource for acquiring fibres which can be used in crafting recipes. Uses global model targeting, allowing any hay bales across the city to be used regardless of location. Config options for an item requirement to be able to pick, skillcheck and cooldown. Optional buy & sell shop. 

## 🔐 Dependencies:
- any framework
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
  
## 🔗 Useful links:
- [Preview video](https://youtu.be/gJlxxr6Jz58)
- [Documentation](https://s4t4n667.gitbook.io/asgaard-developments/free-scripts/s4t4n667_fibrepicking)

## 📦 Items:
```lua
--- ox_inventory/data/items.lua
    ["fibres"] = { 
        label = "Fibres", 
        weight = 10, 
        stack = true, 
        close = false, 
        description = "A handful of fibres.", 
    },

    ["shears"] = { 
        label = "Shears", 
        weight = 100, 
        stack = false, 
        close = false, 
        description = "A pair of shears used for collecting fibres.", 
    },
```

## 📝 Shop example:
```lua
        items = {
            { type = 'buy', label = 'Shears', item = 'shears', icon = 'fa-scissors',  price = 10 },
            { type = 'buy', label = 'Water', item = 'water', icon = 'fa-bottle-water', iconColor = '', price = 10 },
            { type = 'sell', label = 'Fibres', item = 'fibres', icon = 'fa-seedling', iconColor = '', price = 10 },
        },
```

## 📌 Asgaard Developments
I’m a solo FiveM developer creating custom clothing, logos and graphics, liveries, MLO retextures and Discord servers. Lots of different packages available, along with plenty of free assets and scripts for the community to enjoy. 

Join the Discord: [here](https://discord.gg/eFsB5ZFxeq)
