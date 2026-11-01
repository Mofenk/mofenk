# MofenkHub

Premium universal Roblox dashboard & automation framework.

Repository: https://github.com/Mofenk/mofenk

## Overview

MofenkHub is a premium Lua project for Roblox that provides:
- a modern black & white dashboard UI
- draggable floating toggle button
- responsive layout for PC and mobile
- reusable component system for tabs, cards, buttons, toggles, sliders, text boxes, and dropdowns
- a clean loader for loading remote modules
- extensible structure for game automation scripts

This repository is built for reuse across multiple games and scripts and can be expanded with platform-specific automation modules.

## Files

- `loader.lua` — bootstrap script that loads the UI and default game module
- `MofenkUI.lua` — premium dashboard system and modern UI framework
- `games/animedice.lua` — example game-specific automation script
- `README.md` — project documentation

## Quick start

Use this loader in your Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/loader.lua"))()
```

You can also manually load the UI from the repository:

```lua
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
local window = ui.CreateWindow({
    Name = "MofenkHub",
    Theme = "Monochrome",
    ToggleStyle = "Icon",
    ProfileTitle = "VIP Premium",
})

local tab = window:CreateTab("Dashboard", "📊")
tab:AddSection("System")
tab:AddInfoCard("Status", "Online")
tab:AddButton("Open", function()
    print("Clicked")
end)
```

## Features

- premium monochrome dark glass UI
- built-in profile panel
- interactive toggle button with drag support
- smooth hover and motion animation
- responsive auto-scaling UI for desktop/mobile
- tab-based layout
- notification/toast system
- reusable premade widget components
- safe GUI cleanup for compatibility
- lightweight and easy to extend

## UI customization

You can switch themes by using `Theme = "Monochrome"`, `"PureBlack"`, or `"Midnight"`.

Example:

```lua
local window = ui.CreateWindow({
    Name = "Custom UI",
    Theme = "Midnight",
    ToggleStyle = "Icon",
    ProfileTitle = "Professional",
})
```

## Recommended usage pattern

1. Load `loader.lua`.
2. Let the loader fetch `MofenkUI.lua`.
3. Create your custom `Window`.
4. Add tabs and widgets.
5. Connect your automation functions.
6. Use notifications for status updates.

## Notes

- This project is designed to be modular for multiple Roblox games.
- The default loaded script is `games/animedice.lua`.
- If you want to add more game support, create a new script inside `games/` and load it from the loader.
- The interface is intentionally clean and premium so it can be adapted to automation, utility, or gaming tools.

## Helpful links

- GitHub repository: https://github.com/Mofenk/mofenk
- Main branch: https://github.com/Mofenk/mofenk/tree/main
- Loader file: https://github.com/Mofenk/mofenk/blob/main/loader.lua
- UI file: https://github.com/Mofenk/mofenk/blob/main/MofenkUI.lua

## License

This repository is intended for educational, personal, and project-based use. Please use responsibly and respect Roblox platform rules and game policies.

## Support

For updates, modifications, or new game integrations, extend the repository structure and follow the same pattern:
- create a new script in `games/`
- load it from `loader.lua`
- create a new UI tab with `window:CreateTab(...)`
