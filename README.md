# **AmazingAzerothAddon**
Addon for Project Ascension.<br>
This addon currently includes a ability/talent purge assistant as well as a auto reroller for random enchantments.<br>
# **Commands**
## /AA | /amazingazeroth
This is the base command. This command will show the help dilaogue listing all the commands and is always placed before any other command.
## /AA help [Command]
This will present the help dialogue. If you supply an optional Command argument it will attempt to pull a help dialogue for that command. Currently only works for base commands such as "purge" and "reroll".
## /AA Purge
This is the base command for the purge assistant. Typing this command will show the help dialogue for the purge command.
## /AA Purge Ability
This command will instantly attempt to purge your abilities. By default will only reset your abilities if you have Ability Purges remaining.
## /AA Purge Talent
This command will instantly attempt to purge your talents. By default will only reset your talents if you have Talent Purges remaining.
## /AA Purge Both
This command will instantly attempt to purge your abilities and talents both. By default this will only reset your abilities and talents if you have their respective purge tokens.
## /AA Purge UseGold (True|False)
This command will allow you to override the Ability/Talent Purge requirement and allow gold to be used for the resets. By default this is set to False.
## /AA ReRoll
This is the base command for the auto reroller. Typing this command will show the help dialogue for the reroll command.
## /AA ReRoll Name (string)
This command will allow for the auto reroll to search for a string in the names of REs. If the reroll rolls a random enchant with the provided string in the name it will stop rerolling.
## /AA ReRoll Rarity (Rare|Epic|Legendary)
This command will allow for the auto reroll to search for a specific rarity. By default this command will search for the provided rarity or higher.
## /AA ReRoll HigherRarity
This command will change if the rarity search functionality will search specifically for the provided rarity or if higher rarities will stop the rerolling. By default this option is set to True.
## /AA ReRoll UseGold
This command will allow you to override the Mystic Rune requirement and allow gold to be used for the reroll. By default this is set to False.
## /AA ReRoll Clear
This command will reset the name and rarity search settings. Please note that either a rarity or name needs to be provided for the auto reroller to function. Both can be provided as well. If both are provided the auto reroller will stop rerolling if either are found.
## /AA ReRoll Start
This command will start the rerolling process. Make sure the item you are reforging is inside the mystic altar and your settings have been defined.

# **Planned Changes**
* Ability to reset individual options by not providing an input (IE: resetting name or rarity search for the ReRoll)
* Clearer defined help menu with better config
* Menu Based options menu
* Storing options so they save after logging in/out
