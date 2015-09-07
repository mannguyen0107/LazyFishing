# LazyFishing
Ultimate Trove Bot
![preview](https://raw.githubusercontent.com/mannguyen0107/LazyFishing/master/preview.png)

## Features:
- Auto Fishing 

	> Works in all type of liquid: Water, Lava and Chocolate.
	> Uses Memory Address to detect when to reel-in.
	
- Multi Account Launcher

	> An Multi Account Loader.
	> Auto Login.
	
- Auto Drop Boot and Decons Trophy Fish

	> Auto Throw Boot (ATB) and Auto Decons Trophy Fish (ADF) after X minutes.


## Changelog:
- v1.4:

	> * Fixed Remove Selected Account where the saved account folder doesn't get delete.
	> * Added a check to see if the account you are adding is already exist.
	> * Added a messagebox to tell you if your glyph folder path is wrong when you try to save current login account.
	> * Fixed a bug where fishing bot stop after caught 1 fish.
	> * Fixed a bug where bot skip some fishes when decons.
	> * Fixed a bug where the bot try to throw items away while decons.
	> * Added a Boot/Decons count down timer which will count down the time when it will start again.
	> * The Bot now support glyph standalone version just change it in the Settings.
	
- v1.5:

	> * Clean up the script.
	> * Added a check to see if the script is not run as admin then it will restart and run the script as admin.
	> * Improve the login system.
	> * Redo the logic of handling window.


## Installation:
1. Download and install AutoHotKey from the [official website](http://www.autohotkey.com/).

	> AutoHotKey main program is needed to run the .ahk file. Running .ahk script file ratherr than the compiled .exe file to make sure that the script is cleanp and pure without any unintended modification.
	
2. Download files from this repo.

	> You may find the Download ZIP button on the repo page. Extract the .zip file and you can find the files below:
	
	* **LazyFishing.AHK**

		> This is the main script of the bot.
		
	* **FishingClient.AHK**

		> This is the fishing script.
		
	* A Folder **data**

		> This folder contain all the necessary files that the bot needs.
		
3. Run **LazyFishing.AHK** as Administrator.
4. Go into the bot Settings and choose the Glyph Version that you are using.

	> This is very important that you choose the correct Glyph Version.

5. Choose the GLyph Folder Path.

	> Please make sure that you choose the glyph folder path that is appropriate with the Glyph Version you choose in Settings.

6. Add your accounts to the Bot.

	> 1. You need to launch the GlyphClient.exe of the Glyph Version that you chose earlier in Settings or just click the button **Launch Glyph Client**.
	
	> 2. Login to the account that you want to add.
	
	> 3. Click on **Save Current Login**.
	
7. Click on **Start All Accounts**.

	> The Bot will automatically login to all the accounts you added please be patient and wait for it to launch all of them.
	
8. Setting up your charracter.

	> Go to the Settings ingame in the Video section choose graphic: **LOW**. Do this to all your accounts.
	
	> You will need to set up all the character you like to look like the image below this is **VERY IMPORTANT**:

	> ![charsetup](https://raw.githubusercontent.com/mannguyen0107/LazyFishing/master/charsetup.png)
	
9. Start fishing.

	>  After setting up all your character you can now click on the button **Fishing Start (All Account)** to start fishing.
	> If you want the Bot to Auto Throw Boot or Auto Decons Fish then click on the button **Boot and Decons Start**

	
## Hotkeys:
> The hotkeys are all configurable via the Settings. You may change the keys by yourself.

