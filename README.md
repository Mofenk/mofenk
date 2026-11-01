<div align="center">

# 👑 MofenkHub & MofenkUI Framework
**A Professional, Mobile-Friendly, and Highly Optimized Luau UI Library for Roblox**

[![Luau](https://img.shields.io/badge/Luau-Engine-blue.svg)](https://create.roblox.com/)
[![Mobile Friendly](https://img.shields.io/badge/Mobile-Compatible-green.svg)](https://roblox.com/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

</div>

---

## ✨ Overview

**MofenkHub** is a premium universal Roblox dashboard and automation framework powered by **MofenkUI**—a sleek, monochromatic Lua UI library designed with modern glassmorphism aesthetics. It provides a seamless user experience across both mobile (Android/iOS executors) and PC platforms, featuring smooth spring/tween animations, auto-scaling, interactive floating toggles ("M" button), live FPS/Ping monitors, and immersive audio feedback.

---

## 📂 Project Structure

- `loader.lua` — Bootstrap script that loads the core UI library and default game module.
- `MofenkUI.lua` — Premium dashboard system and mobile-friendly UI framework.
- `games/animedice.lua` — Example game-specific automation script (Anime Dice).
- `README.md` — Project documentation and guides.

---

## 🚀 Quick Start & Usage Tutorial

To load and use **MofenkUI** directly in your script execution environment, or to build your own game automation script, follow the example below:

```lua
-- 1. Load MofenkUI Framework from GitHub
local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()

-- 2. Initialize Main Window
local Window = MofenkUI:CreateWindow({
    Name = "MOFENK HUB | Anime Dice"
})

-- 3. Create Profile Tab (Auto-renders Player Headshot Avatar, Display Name & ID)
Window:CreateProfileTab()

-- 4. Create Custom Tab (Clean text layout without emojis)
local TabFarm = Window:CreateTab("Farming")

-- 5. Create Group Container inside Tab
local GroupFarm = TabFarm:CreateGroup("Auto Farm Setup")

-- 6. Add Interactive Components
GroupFarm:AddToggle("Auto Roll Dice", false, function(state)
    print("Auto Roll status:", state)
end)

GroupFarm:AddSlider("Delay Collect (Sec)", 0.5, 10.0, 2.0, function(value)
    print("Delay set to:", value)
end)

GroupFarm:AddButton("Execute Action", function()
    print("Button clicked!")
end)
```

---

## 🛠️ Component API Reference

| Method / Component | Description |
| :--- | :--- |
| `MofenkUI:CreateWindow(config)` | Initializes the main window container, drag systems, and auto-scaler. |
| `Window:CreateProfileTab()` | Generates a sleek player card featuring HeadShot avatar, Display Name, and User ID. |
| `Window:CreateTab(name)` | Creates a new sidebar tab page with smooth transition animations. |
| `Tab:CreateGroup(name)` | Creates a grouped card container to organize elements neatly. |
| `Group:AddButton(text, callback)` | Standard button with click animation and audio feedback. |
| `Group:AddToggle(text, default, callback)` | Interactive on/off switch with smooth knob translation. |
| `Group:AddSlider(text, min, max, default, callback)` | Drag-to-adjust numeric slider with real-time value updating. |
| `Group:AddInput(text, table, key, isNum)` | Textbox input field synchronized directly with a configuration table. |
| `Group:AddDropdown(title, options, table, key, isMulti)` | Dropdown selection supporting search filtering and multi-selection mode. |

---

## ✨ Key Features

- **Monochromatic Aesthetic:** Clean dark-mode theme built for high-contrast visibility and a professional look.
- **Adaptive Auto-Scale (`UIScale`):** Automatically resizes based on the user's viewport dimensions with manual zoom controls.
- **Interactive Floating Logo ("M"):** A draggable, boundary-clamped floating button to toggle UI visibility instantly anywhere on screen.
- **Fluid Animations:** Powered by `TweenService` with smooth scale-up, fade, and spring tab-switching effects.
- **Interactive Audio Feedback:** Integrated click sound effects for all interactive buttons, toggles, and sliders.
- **Live Network Monitor:** Real-time FPS and Ping counter with automated dynamic color-coding (Green for stable, Yellow for moderate, Red for lag).

---

## 📄 License

This repository is intended for educational, personal, and project-based use. Please use responsibly and respect Roblox platform rules and game policies.
