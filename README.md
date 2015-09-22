# LazyFishing
![preview](https://raw.githubusercontent.com/mannguyen0107/LazyFishing/master/preview.gif)

## Features:
- Auto Fishing 

	> * Works in all type of liquid: Water, Lava and Chocolate.
	> * Uses Memory Address to detect when to reel-in.
	> * Reel-In counter.
	
- Multi Account Launcher

	> * An Multi Account Loader.
	> * Auto Login.
	
- Auto Drop Boot and Decons Trophy Fish

	> * Auto Throw Boot (ATB) and Auto Decons Trophy Fish (ADF) after X minutes.
	> * You can choose what inventory slots you want to ATB or ADF.


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
	> * v1.5.1 (HotFix): 
		* Fixed a bug where Settings doesn't save the Glyph Version info. 
	> * v1.5.2 (HotFix): 
		* Fixed the login system finally got it working correctly.
	> * v1.5.3 (HotFix):
		* Fixed a bug where fishing bot randomly stop.
	> * v1.5.4 (HotFix): 
		* Change the time when fishing bot check for readmemory to increase the CPU performance.
	> * v1.5.5 (HotFix): 
		* Added a better way to detect if the bot is stuck when fishing it will restart itself.
	> * v1.5.6 (HotFix): 
		* Fixed FishingState ReadMemory.
	
- v1.6:

	> * - Redesign the bot GUI.
	> * Added Nippy fishing method v1.1.
	> *  Added a new feature which gives the user the choice to choose which account will be fishing, which account will not be fishing. Also, which account will drop boot or decons.
	> *  Added Log Screen.
	> *  Redo Boot/Decons bot no more image search.
	> * v1.6.1 (HotFix): 
		* Fixed problem where bot never click on Play button to start the game.
		* Fixed a possible problem that cause the bot cant start fishing which is the game window didn't get rename.
		* Added log to when the bot click Play button and changing window name (for debugging purpose).

- v1.7:

	> * Added auto Anti-AFK if the client errors out too much.
	> * Added a way for users to select which slots they want to drop boot or decons on.
	> * Added a few bug fix for fishing bot (Thanks to Nippy).
	> * Added resize game window button, so you could enlarge the game window to see chat trade then you can resize it without relaunch it.
	> * Clean up un used variables (increases CPU performance)
	> * Clean up the bot folder. Deleted un use images.
	> * Seperate code into many sections (for development purpose).
	> * Added auto shutdown computer or trove.
	> * v1.7.1 (HotFix):
		* Fixed Resize All button.
		* Fixed a bug where it would clear log file when press Ctrl + F1.
		* Change the selected slot image from cross to tick.
	> * v1.7.2 (HotFix):
		* Fixed count down clock of shutdown.
		* Fixed a bug where when you stop fishing on selected account all the others account would stop with it.
		* Improve fishing bot (thanks Nippy).
		* Fixed auto shutdown trove not closing all window of trove running.

- v1.8:

	> * Added PushBullet Notification System. You are now able to check on all your accounts 24/7 without the need of look at your computer.
	> * Added ReadMe
	> * Fixed countdown clocks.
	> * Fixed a bug with fishing Stop Selected Account.
	> * Improve boot drop.
	> * Added edit for time before memory scan start so user can change the setting for x2 fishing week.
	> * Fixed a bug where the mouse get freeze if the user have wrong settings when launch accounts.
	> * Change the default size of Trove window it is now smaller, you guys might be able to run more accounts.
	> * Added a resize button incase the bot didnt resize your game window correctly.
	> * Separate boot drop and decons out from the main script so it doesnt conflict with fishing bot.
	> * Fixed how the bot reload fishing list when you add a new account that it could make the fishing info of current account get reset.
	> * Fixed log screen timer, it will now shows the correct time.

## Installation:
1. Download and install AutoHotKey from the [official website](http://www.autohotkey.com/).

	> AutoHotKey main program is needed to run the .ahk file. Running .ahk script file ratherr than the compiled .exe file to make sure that the script is cleanp and pure without any unintended modification.
	
2. Download files from this repo.

	> You may find the Download ZIP button on the repo page. Extract the .zip file and you can find the files below:
	
	* **LazyFishing.AHK**

		> This is the main script of the bot.
		
	* A Folder **LFBot**

		> This folder contain all the logic of the bot.
		
	* A Folder **data**

		> This folder contain all the necessary files that the bot needs.
		
3. Run **LazyFishing.AHK** as Administrator.
4. Go to "Login Bot" tab, choose Config then choose the Glyph Version that you are using and its Folder Path.

	> This is very important that you choose the correct Glyph Version.
	> Please make sure that you choose the glyph folder path that is appropriate with the Glyph Version you chose.

6. Add your accounts to the Bot.

	> 1. You need to launch the GlyphClient.exe of the Glyph Version that you chose earlier or just click the button **Launch Glyph Client**.
	> 2. Login to the account that you want to add.
	> 3. Click on **Save Current Login**.
	> 4.  Keep in mind that you might have to re-add your account every 48-72 hours due to Trove system which reset the hash .dat files. 
	> 5. When you add your account, 2 message box will appear just read it and follow.
	
7. Click on **Launch All Accounts**.

	> The Bot will automatically login to all the accounts you added please be patient and wait for it to launch all of them.
	
8. Setting up your charracter.

	> Go to the Settings ingame in the Video section choose graphic: **LOW**. Do this to all your accounts.
	
	> You will need to set up all the character you like to look like the image below this is **VERY IMPORTANT**:

	> ![charsetup](https://raw.githubusercontent.com/mannguyen0107/LazyFishing/master/charsetup.png)
	
9. Start fishing.

	>  Now go to the **Fishing Bot Tab** and click on **Start All**
	
10. Start auto throw boot and auto decons.

	>  if you want it to start auto drop boot and decons then go to **Boot/Decons Bot Tab** and click on **Start** (When it is dropping boot and decons you will not be able to use your computer). Also, This will **ONLY** work when you already started fishing bot.
	
11. Start notification system.

	> If you want to check on all of your bot accounts without the need of looking at your
	computer then:
		* Go to PushBullet website at (https://www.pushbullet.com) and register.
		* Download PushBullet app on your smart phone.
		* Login to PushBullet on your smartphone.
		* Go to your browser and login into PushBullet website. Then go to settings and
		under Account you should see Access Token.
		* Copy the Access Token and paste it to the Access Token in Notify Tab of 
		LazyFishing.
		* Change the settings of the Notification system to your liking and click on
		Save Settings.
		* Click on Test Token and wait abit to see if you receive a new note on PushBullet.
		If you do receive it that means your token is working. If you DO NOT receive any new
		note then go to the Log Screen and check out what's going on.
		* Now after set everything up just click Enable.

