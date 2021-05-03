# Counter-Strike Condition Zero Weapons Project
> Custom weapons project for Sven Co-op

This original project is brought to you by the following super dedicated team members: D.N.I.O. 071, R4to0, and me (KernCore). This project started in late October of 2020. This is a Re-release of the original project that started in 2016.
This is the modified version with the weapons from the Counter Strike Condition Zero, Ported by Garompa, Mementocity, and me (SV BOY). This is basicly just the kerncore's cs 1.6's plugin with different assets and some minor changes.

## The Weapons

* .228 Compact (weapon_csczp228)
* .40 Dual Elites (weapon_csczdualelites)
* 9×19mm Sidearm (weapon_csczglock18)
* Bullpup (weapon_csczaug)
* C4 Bomb (weapon_csczc4)
* Clarion 5.56 (weapon_csczfamas)
* CV-47 (weapon_csczak47)
* D3/AU-1 (weapon_csczg3sg1)
* ES C90 (weapon_csczp90)
* ES Five-SeveN (weapon_csczfiveseven)
* ES M249 SAW (weapon_csczm249)
* High Explosive Grenade (weapon_csczhegrenade)
* IDF Defender (weapon_csczgalil)
* Ingram MAC-10 (weapon_csczmac10)
* K&M .45 Tactical (weapon_csczusp)
* K&M Sub-Machine Gun (weapon_csczmp5navy)
* K&M UMP45 (weapon_csczump45)
* Knife (weapon_csczknife)
* Krieg 550 Commando (weapon_csczsg550)
* Krieg 552 (weapon_csczsg552)
* Leone 12 Gauge Super (weapon_csczm3)
* Leone YG1265 Auto Shotgun (weapon_csczxm1014)
* Magnum Sniper Rifle (weapon_csczawp)
* Maverick M4A1 Carbine (weapon_csczm4a1)
* Night Hawk .50C (weapon_csczdeagle)
* Schmidt Machine Pistol (weapon_cscztmp)
* Schmidt Scout (weapon_csczscout)

## Gameplay Video

Video:
[![]()](https://youtu.be/KYDw9y5o8Vc)
*by SV BOY.*

## Screenshots
[![](https://imgur.com/3NBBUmP)](https://imgur.com/3NBBUmP)
[![](https://imgur.com/Y20AzgM)](https://imgur.com/Y20AzgM)
[![](https://imgur.com/OCGwZUl)](https://imgur.com/OCGwZUl)
[![](https://imgur.com/sK6HTRR)](https://imgur.com/sK6HTRR)
[![](https://imgur.com/KUCW9xA)](https://imgur.com/KUCW9xA)
[![](https://imgur.com/uvN9bsW)](https://imgur.com/uvN9bsW)

## Installation Guide

1. Registering the weapons as plugins (Good for server operators, and most people):
	1. Download the pack from one of the download links below
	2. Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	3. Open up *`default_plugins.txt`* located in **`Steam\steamapps\common\Sven Co-op\svencoop\`**
	4. Add these lines to the file:
	```
	"plugin"
	{
		"name"			"Counter-Strike Condition Zero Weapons"
		"script"		"../maps/cscz/cscz_register"
		"concommandns"	"cscz"
	}
	```
	5. Load any map of your preference;
	6. Type in chat *\buy* or type in console give *name of the weapon* and enjoy.

2. Registering the weapons as map_scripts (Good for map makers):
	1. Download the pack from one of the download links below
	2. Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	3. Open up any map *.cfg* (i.e: **svencoop1.cfg**) and add this line to it:
	```
	map_script cscz/cscz_register
	```
	4. Load up the map you chose;
	5. Type in chat *\buy* or type in console give *name of the weapon* and enjoy.

## Additional Content

This pack includes a heavily modified Buymenu made specifically for it.  
Here are the following commands that can be used in the Buymenu:

```
// Opening the Buy menu in the chat:
buy
/buy
!buy
.buy
\\buy
#buy
$buy
@buy
~buy
|buy
/b
!b
.b
\\b
#b
$b
@b
~b
|b

// Opening the Buy menu in the console:
.buy

// Buying a specific weapon/ammo (without the weapon_cscz prefix) without the menu:
<menu opening command here> <entity identifier here> <weapon name here> ie:
!buy w csczp90 (will directly buy a P90 for you) or 
/buy a csczp90 (will directly buy ammo for the P90 for you)

// Buying ammo for the current equipped weapon:
<menu opening command here> ammo ie:
!buy ammo or
/buy ammo
```

Server commands (in case you registered the weapons as a plugin):
```
as_command cscz.bm_maxmoney <value>
as_command cscz.bm_moneyperscore <value>
as_command cscz.bm_startmoney <value>
```

## Notes

This pack includes a *.fgd* file and a *.res* file (the .res file should not be needed).  
There are several notable differences here compared to the old project:  
* **Organization**: The project is more organized than ever before. This helps reduce the amount of clutter and resources sent to the player.  
* **Original Rifle Muzzleflashes**: With the knowledge obtained with past projects, we're able to bring you the original X shaped Muzzleflash for rifles back, without conflicting with the original game.  
* **Original HE Grenade Entity**: The HE Grenade projectile thrown by the player should behave closely to the original projectile.  
* **Customization without modification of original scripts**: Similarly to the Insurgency Project, you're now able to modify most of the entity data, without modifying the original script, in your own map script.  
* **Original C4 Entity**: Thanks to Nero for making the original projectile, the code has been cleaned up a little bit and it allows for more customization.  
* **Original Scope for Sniper Rifles**: Thanks for D.N.I.O. 071 for making a custom scope viewmodel that fits very well with the original sprites used in condition zero.  
* **Fixed Player Models**: The original Condition Zero player models were fixed to fit the Sven's Playermodel skeleton, no more aiming down.  
* **Buy Menu Similar to Condition Zero**: The menu has been redesigned to closely resemble the original Buy Menu, with the $ added as well, similarly to the Insurgency Project.  
* **Magazine Entities for Every Weapon**: Thanks for Garompa for compiling the model which includes all magazines for all weapons, unfortunately this means the old magazine entities no longer exist, this was necessary in order to support dropping ammo for each weapon entity.  
* **Knife Backstabbing**: The original backstabbing functionality of the knife has been restored in this project.  

Shoutout for Solokiller for helping me initially in 2016 with this project.  

## Credits

You are authorized to use any assets in this pack as you see fit, as long as you credit us and whoever contributed to the making of this pack.  
There's a very long list of people/teams in the file: *cscz_credits.txt*, this file specifies the authors of every single asset that is being used in the making of this project.

### You are authorized to use any assets in this pack as you see fit, as long as:
* You credit everyone who contributed to it.

### You are not permitted to:
* Re-pack it without the project author's consent.
* Use any assets included in this project without crediting who made them.
* Earn money from this pack or any other assets used.
* Upload it somewhere else without credits.

## Updates

### Update 1.1:
* Fix player's speed not being affected when aiming with Sniper Rifles.

## Download Links

Total Size Compressed: 26 MB

(.7z) [GitHub]()
