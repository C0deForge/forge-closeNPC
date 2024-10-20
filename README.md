
# Forge NPC Car Lock Script

## Description

This script allows players to lock NPC vehicles and perform vehicle lockpicking. It has been thoroughly tested with the **ESX** framework and provides a robust system for managing vehicle locking and unlocking using a lockpick minigame. 
A bridge for **QB Core** has been added, but it **has not been fully tested** with QB. 

### Important Note for QB Users

Although compatibility for **QB Core** has been added, it has not been tested in the same way as the ESX version. **QB Core** already provides its own vehicle lockpicking system, which works efficiently.
Therefore, it is recommended to use this script with **ESX** for better stability and reliability. If you choose to use it with QB, be aware that it may not work as expected.

## Requirements

- **ESX Framework** (fully tested)
- **QB Core Framework** (use at your own risk, not fully tested)
- **Lockpick Minigame Resource** (required for lockpicking interaction) - [Lockpick Dependency](https://github.com/baguscodestudio/lockpick)
- **OX Inventory or QB Inventory** (for handling the lockpick item in inventories)

## Installation

1. Place the `forge-closeNPC` folder in your `resources` directory.
2. Add the following to your `server.cfg`:
   ```lua
   ensure forge-closeNPC
   ```

3. Install the required dependencies (ESX or QB Core, Lockpick minigame, OX Inventory if applicable).

## Configuration

The script can be configured via the `config.lua` file. Here are some important options:

- **Framework Selection**: Choose between `ESX` and `QB` in `config.lua`.
  ```lua
  Config.Framework = 'ESX' -- or 'QB'
  ```

- **Inventory System**: If using QB, ensure that the correct inventory system is configured.
  ```lua
  Config.Inventory = 'OX' -- or 'QB'
  ```

- **Lock Type**: Define the type of locking mechanism used for NPC vehicles.
  ```lua
  Config.LockType = 2 -- Refer to FiveM docs for more types
  ```

- **Debug Mode**: Enable or disable debug messages.
  ```lua
  Config.Debug = true
  ```

## Exports

This script provides the following exports to interact with the lockpicking functionality:

- **startLockpick**
  - Usage: `exports['forge-closeNPC']:startLockpick()`
  - Description: Initiates the lockpicking minigame for the player.

## Dependencies

This script relies on the following resources:

- **ESX** or **QB Core** framework.
- **Lockpick Minigame Resource** (`lockpick`) - [Lockpick Dependency](https://github.com/baguscodestudio/lockpick)
- **OX Inventory** or **QB Inventory** (for managing lockpick items).

## Technical Support

For technical support, please join the CodeForge Discord: [CodeForge Discord](https://discord.gg/UTVssdrXRV)
