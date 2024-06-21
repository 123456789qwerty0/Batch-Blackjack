@echo off
setlocal enabledelayedexpansion
title Blackjack
color B
:boot
cls
echo Loading...
ping localhost -n 3 > nul
echo.
echo Done
ping localhost -n 2 > nul
cls
echo --------------------------------
echo Blackjack!
echo.
pause
goto variables

		rem This is the autosave feature. Assuming the proper directory is found, it will automatically save your
		rem stats to external files whenever you return to the main menu. It is disabled by default.

:autosave
if not exist autosave.cfg goto menu2
if %autosave% == 0 goto menu
if %gamesplayed% LSS 1 goto menu2
cls
echo Autosaving...
ping localhost -n 2 > nul
for %%a in (level experience cash wins losses played earnedcash lostcash mostcash bankrupt) do echo !%%a! > %%a.stat
for %%a in (autosave) do echo !%%a! > %%a.cfg
goto menu2
	:autosaveconfig
echo.
if %directorymade% == 0 echo No directory found, cannot enable autosave.
if %directorymade% == 0 pause
if %directorymade% == 0 goto menu
if %autosave% == 0 goto autoenable
goto autodisable
	:autoenable
set /a autosave = 1
echo Autosave Enabled
pause
for %%a in (autosave) do echo !%%a! > %%a.cfg
goto menu2
	:autodisable
set /a autosave = 0
echo Autosave Disabled
pause
for %%a in (autosave) do echo !%%a! > %%a.cfg
goto menu2

		REM Below are variables that are designed to change / reset during normal play.

:variables
set vsn=4.0
set /a bankruptlimit = 50
set /a cash = 500
set stake=undef
set /a bet = 0
set /a total = 0
set /a dtotal = 0
set /a blackjack = 21
set /a total = 0
set /a dtotal = 0
set /a lastgame = 0
set /a gamesplayed = 0
set /a expwin = 20
set /a exploss = 10
set /a session = 0
set lastgamemod=undef
set op1=menu
set op2=reset
set op3=version
set op4=stat
set op4a=stats
set op5=cheat

		REM Stats are the variables which are saved and loaded externally.

:stats
set /a level = 0
set /a experience = 0
set /a cash = 500
set /a wins = 0
set /a losses = 0
set /a played = 0
set /a earnedcash = 0
set /a lostcash = 0
set /a mostcash = 500
set /a bankrupt = 0

:settings
set /a autosave = 0

		REM Save feature - Checks to see if the "datafiles" directory exists. If it does, it will save player stats externally. If not,
		REM it will ask if you'd like to create the directory. You can still play normally if you choose not to create the folder, however
		REM you will not be able to save or load stats.

:savecheck
cls
if exist marker.phf cd..
if exist stats cd..
if exist datafiles set /a directorymade = 1
if exist datafiles goto changedir
echo No save directory found, would you like to create one now? (Y/N)
echo This will create a folder called "datafiles" in this file's directory.
set /p loadsave=
if %loadsave% == y goto createdir
if %loadsave% == n goto dontsave
goto savecheck
	:createdir
mkdir datafiles
cd datafiles
mkdir stats
cd stats
(
echo This is a flag file, please do not delete.
)>marker.phf
cd..
cd..
set /a directorymade = 1
goto menu
	:dontsave
cls
echo Not creating a save directory will prevent you from saving your games and stats, including all cash won.
echo.
echo Are you sure you want to continue without a save directory?
echo 1) Yes I'm sure
echo 2) No, create a directory
set /p loadsave=
if %loadsave% == 1 goto dontsave2
if %loadsave% == 2 goto createdir
goto dontsave
	:dontsave2
set /a directorymade = 0
goto menu

:savegame
cls
if %directorymade% == 0 goto savecheck
if exist stats cd..
if exist datafiles cd datafiles
if exist stats cd stats
for %%a in (level experience wins losses played earnedcash lostcash mostcash bankrupt) do (
if exist %%a.stat (
	goto confirmsave
	) else (
	goto savegamecont
	)
)
goto savegamecont
	:confirmsave
echo Save files found. Confirm overwrite? (Y/N)
set /p over=
if %over% == y goto savegamecont
if %over% == n goto menu
goto confirmsave
	:savegamecont
cls
echo Saving game to datafiles...
ping localhost -n 3 > nul
for %%a in (level experience cash wins losses played earnedcash lostcash mostcash bankrupt) do echo !%%a! > %%a.stat
for %%a in (autosave) do echo !%%a! > %%a.cfg
echo.
echo Save complete
echo.
pause
goto menu

		REM Load feature - Checks if "datafiles" directory exists as well as any stat files that may have been saved. If they do, it will load player stats
		REM into the game.

:loadgame
cls
if %directorymade% == 0 goto savecheck
set /a loaderror = 0
echo Checking game files...
if exist datafiles cd datafiles
if exist stats cd stats
ping localhost -n 3 > nul
echo.
for %%a in (level experience wins losses played earnedcash lostcash mostcash bankrupt) do (
if exist %%a.stat (
	echo %%a found.
	) else (
	echo Save files missing, saving the game can resolve this issue.
	echo.
	pause
	goto menu
	)
)
	:loadgamecont
echo.
if %loaderror% == 1 echo Missing files, cannot load game. Try saving.
if %loaderror% == 1 echo.
if %loaderror% == 1 pause
if %loaderror% == 1 goto menu
	:loadgamefinal
set /p level=<level.stat
set /p experience=<experience.stat
set /p cash=<cash.stat
set /p wins=<wins.stat
set /p losses=<losses.stat
set /p played=<played.stat
set /p earnedcash=<earnedcash.stat
set /p lostcash=<lostcash.stat
set /p mostcash=<mostcash.stat
set /p autosave=<autosave.cfg
echo All files found and loaded.
echo.
pause
goto menu

:changedir
if not exist datafiles goto savecheck
cd datafiles

		REM Main menu options below.

:menu
if exist autosave.cfg set /p autosave=<autosave.cfg
if %autosave% == 1 goto autosave

:menu2
cls
if %directorymade% == 0 echo NO DIRECTORY FOUND, UNABLE TO SAVE GAME
if %directorymade% == 0 echo.
set /a bet = 0
echo Cash = $%cash%
echo.
echo 1) Play
echo 2) Save Game
echo 3) Load Game
echo 4) How To Play
echo 5) Debug Commands
echo 6) Autosave
echo 7) Stats
echo 8) Exit
if %cash% LSS 50 echo 10) Restore Cash
if %directorymade% == 0 echo A) Create Save Directory
set /p menu=
if %menu% == 1 goto modes
if %menu% == 2 goto savegame
if %menu% == 3 goto loadgame
if %menu% == 4 goto how
if %menu% == 5 goto command
if %menu% == 6 goto autosaveconfig
if %menu% == 7 goto showstats
if %menu% == 8 goto exit
if %menu% == 10 goto bankrupt
if %menu% == A goto directorymaker
if %menu% == %op2% goto boot
if %menu% == %op3% goto version
if %menu% == %op5% goto cash
goto menu

:directorymaker
if %directorymade% == 1 goto menu
goto savecheck

:bankrupt
if %cash% GTR %bankruptlimit% goto menu
cls
echo You can file bankruptcy and restore $250. This will increase your Times Bankrupt stat by one and will cost you
echo one level. If you are Level 0, you can still restore cash for free. Confirm? (Y/N)
set /p bank=
if %bank% == y set /a cash = %cash% +250
if %bank% == y set /a bankrupt = %bankrupt% +1
if %bank% == y set /a level = %level% -1
if %bank% == n goto menu2
if %level% lss 0 set /a level = 0
goto menu

:showstats
cls
echo (Stats only change during Casino games).
echo.
echo Casino Level: %level%
echo.
echo Casino Experience: %experience%
echo.
echo Current cash: $%cash%
echo.
echo Total Wins: %wins%
echo.
echo Total Losses: %losses%
echo.
echo Games played: %played%
echo.
echo Total cash earned: $%earnedcash%
echo.
echo Total cash lost: $%lostcash%
echo.
echo Most cash held at once: $%mostcash%
echo.
echo Times bankrupt: %bankrupt%
echo.
pause
goto menu2

:cash
cls
echo What cheat do you want to activate?
echo 1) Add or remove money
echo 2) Unlock all casino leagues
echo 3) -Back-
set /p cheatch=
if %cheatch% == 1 goto cash2
if %cheatch% == 2 goto cash3
if %cheatch% == 3 goto menu2
goto cash
	:cash2
cls
echo Your current cash is $%cash%, would you like to change it? (Y/N)
set /p change=
if %change% == y goto change
if %change% == n goto menu
if %change% == %op1% goto menu
goto cash
		:change
cls
echo Enter your desired cash value:
set /p cashchange=
if %cashchange% == %op1% goto menu
if %cashchange% LSS 1 echo Unknown or invalid input.
if %cashchange% GTR 0 goto changeconf
pause
goto change
		:changeconf
cls
echo Confirm change cash to $%cashchange%? (Y/N)
set /p conf=
if %conf% == y set /a cash = %cashchange%
if %conf% == y goto menu
if %conf% == n goto change
goto changeconf
	:cash3
set /a level = 999
echo.
echo All leagues unlocked.
echo.
pause
goto menu2

:how
cls
echo Draw a card every round to increase your score without going over 21.
pause
goto menu

:command
cls
echo 'menu' - Returns to the game menu.
echo 'reset' - Resets the game and all variables. Only used from menu.
echo 'version' - Shows the version of Blackjack currently running.
echo 'cheat' - Allows you to change your total cash, or unlock all casino leagues.
echo.
pause
goto menu

:version
cls
echo You are currently running v%vsn% of Blackjack.
pause
goto menu

:modes
cls
echo Choose a game mode:
echo 1) Casual
echo 2) Casino
echo 3) -Info-
set /p mode=
if %mode% == 1 goto gsetup
if %mode% == 2 goto csnsetup
if %mode% == 3 goto info
if %mode% == %op1% goto menu
goto modes

:info
cls
echo Casual is a normal game of Blackjack, whereas Casino is a game involving bets, money, and stats.
echo.
pause
cls
echo In Casual, money cannot be earned or lost. In Casino, it can be.
echo.
pause
cls
echo When you win a game in Casino mode, you gain experience which is used to unlock new and more rewarding
echo tournaments. However, losing a game will decrease your experience by half the usual gain.
echo.
goto modes

		REM Casual game begins here. Core game functions from here on out.

		REM The lines below generate all five of the player and dealer's potential draws.

:gsetup
set /a total = 0
set /a dtotal = 0
set /a playcard1 = %random% %% 11+1
set /a playcard2 = %random% %% 11+1
set /a playcheck = %playcard1% + %playcard2%
if %playcheck% == 22 goto gsetup
set /a playcard3 = %random% %% 11+1
set /a playcard4 = %random% %% 11+1
set /a playcard5 = %random% %% 11+1
	:dealcards
set /a dealcard1 = %random% %% 11+1
set /a dealcard2 = %random% %% 11+1
set /a dealcheck = %dealcard1% + %dealcard2%
if %dealcheck% == 22 goto dealcards
set /a dealcard3 = %random% %% 11+1
set /a dealcard4 = %random% %% 11+1
set /a dealcard5 = %random% %% 11+1

		REM Player's turn begins here.

:game
cls
echo Your first card is %playcard1%.
echo Your second card is %playcard2%.
echo.
echo Dealers up card is %dealcard1%
set /a total = %playcard1% + %playcard2%
if %total% == %blackjack% goto pblackjack
echo Your total is %total%.
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto pcard3
if %action% == 2 goto dcard
if %action% == %op1% goto menu
if %action% == %op2% goto start
goto game
	:pcard3
set /a total = %total% + %playcard3%
if %total% == 21 goto pblackjack
if %total% GTR 21 goto playerbust
cls
echo You draw a %playcard3%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%    
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto pcard4
if %action% == 2 goto dcard
if %action% == %op1% goto menu
goto game
	:pcard4
set /a total = %total% + %playcard4%
if %total% == 21 goto pblackjack
if %total% GTR 21 goto playerbust
cls
echo You draw a %playcard4%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%   
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto pcard5
if %action% == 2 goto dcard
if %action% == %op1% goto menu
goto game
	:pcard5
set /a total = %total% + %playcard5%
if %total% == 21 goto pblackjack
if %total% GTR 21 goto playerbust
cls
echo You draw a %playcard3%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%    
echo.
pause
goto dcard

		REM Dealer's turn begins here.

:dcard
cls
echo The dealer will now draw.
ping localhost -n 3 > nul
cls
set /a dtotal = %dealcard1% + %dealcard2%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
set /a dealnum = 2
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto dcard3
if %dtotal% GTR 16 goto dstop
if %dtotal% == 21 goto dblackjack
if %dtotal% GTR 21 goto dealerbust
	:dcard3
cls
set /a dtotal = %dtotal% + %dealcard3%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
set /a dealnum = 3
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto dcard4
if %dtotal% GTR 16 goto dstop
if %dtotal% == 21 goto dblackjack
if %dtotal% GTR 21 goto dealerbust
	:dcard4
cls
set /a dtotal = %dtotal% + %dealcard4%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
echo Fourth card: %dealcard4%
set /a dealnum = 4
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto dcard5
if %dtotal% GTR 16 goto dstop
if %dtotal% == 21 goto dblackjack
if %dtotal% GTR 21 goto dealerbust
	:dcard5
cls
set /a dtotal = %dtotal% + %dealcard5%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
echo Fourth card: %dealcard4%
echo Fifth card: %dealcard5%
set /a dealnum = 5
ping localhost -n 3 > nul
if %dtotal% == 21 goto dblackjack
if %dtotal% GTR 21 goto dealerbust
goto dstop

:dstop
if %dtotal% == 21 goto dblackjack
if %dtotal% GTR 21 goto dealerbust
echo.
echo Dealer stopped at %dtotal%
echo.
if %dtotal% == %total% echo Push. No winner. %total% - %dtotal%.
if %dtotal% GTR %total% echo Dealer has higher score, %total% - %dtotal%.
if %dtotal% GTR %total% echo Dealer wins.
if %total% GTR %dtotal% echo Your score is higher, %total% - %dtotal%.
if %total% GTR %dtotal% echo You win!
echo.
pause
goto playagain

:pblackjack
cls
echo %total% Blackjack! You win!
echo.
pause
goto playagain

:dblackjack
echo.
echo Dealer has blackjack. Dealer wins.
echo.
pause
goto playagain

:playerbust
cls
echo Bust! Your total is %total%. Dealer wins!
echo.
pause
goto playagain

:dealerbust
echo.
echo Dealer has %dtotal%, dealer bust. You win!
echo.
pause
goto playagain

:playagain
cls
echo Play Again? (Y/N)
set /p pa=
if %pa% == y goto gsetup
if %pa% == n goto menu
goto playagain

		REM Casino game begins here

:csnsetup
set /a total = 0
set /a dtotal = 0
set /a playcard1 = %random% %% 11+1
set /a playcard2 = %random% %% 11+1
set /a playcheck = %playcard1% + %playcard2%
if %playcheck% == 22 goto csnsetup
set /a playcard3 = %random% %% 11+1
set /a playcard4 = %random% %% 11+1
set /a playcard5 = %random% %% 11+1
	:csndealcards
set /a dealcard1 = %random% %% 11+1
set /a dealcard2 = %random% %% 11+1
set /a dealcheck = %dealcard1% + %dealcard2%
if %dealcheck% == 22 goto csndealcards
set /a dealcard3 = %random% %% 11+1
set /a dealcard4 = %random% %% 11+1
set /a dealcard5 = %random% %% 11+1

:csnstake
set /a expwin = 20
set /a exploss = 10
cls
echo Cash: $%cash%
echo.
if %lastgamemod% == 1 echo Last game, you won $%lastgame% !
if %lastgamemod% == 2 echo Last game, you lost $%lastgame%...
if %lastgamemod% == 1 echo.
if %lastgamemod% == 2 echo.
if %session% lss 0 echo You are currently suffering a net loss of $%session% for this session...
if %session% lss 0 echo.
if %session% gtr 0 echo You are currently up by $%session% for this session !
if %session% gtr 0 echo.
echo Choose a Casino league.
echo 1) No League
if %level% gtr 9 echo 2) Bronze League
if %level% lss 10 echo 2) (LOCKED) Bronze League
if %level% gtr 24 echo 3) Silver League
if %level% lss 25 echo 3) (LOCKED) Silver League
if %level% gtr 39 echo 4) Gold League
if %level% lss 40 echo 4) (LOCKED) Gold League
if %level% gtr 44 echo 5) Diamond League
if %level% lss 45 echo 5) (LOCKED) Diamond League
echo 6)  -Info-
set /p stake=
if %stake% == 1 goto bet
if %stake% == 2 goto bet2
if %stake% == 3 goto bet3
if %stake% == 4 goto bet4
if %stake% == 5 goto bet5
if %stake% == 6 goto betinfo
if %stake% == %op1% goto menu

:betinfo
cls
echo Leagueless games are free for anyone to attend regardless of level, and
echo require bets between $10 - $1,000.
echo Experience Gain: 20
echo Experience Loss: 10
echo.
echo Bronze League requires Level 10 or higher, and bets between $1,000 - $50,000.
echo Experience Gain: 50
echo Experience Loss: 25
echo.
echo Silver League requires Level 25 or higher, and bets between $50,000 - $500,000.
echo Experience Gain: 150
echo Experience Loss: 75
echo.
echo Gold League requires Level 40 or higher, and bets between $500,000 - $20,000,000.
echo Experience Gain: 400
echo Experience Loss: 200
echo.
echo Diamond League requires Level 45 or higher, and bets between $20,000,000 - $1,000,000,000.
echo Experience Gain: 800
echo Experience Loss: 400
echo.
pause
set stake=undef
goto csnstake

:bet
set stake=low
	:bet1con
cls
echo Cash = $%cash%
echo Leagueless game
echo.
echo Enter your bet. Bet must be between $10 and $1,000.
set /p bet=
if %bet% == %op1% goto menu
if %bet% LSS 10 echo Bet must be greater than $10.
if %bet% LSS 10 pause
if %bet% LSS 10 goto bet1con
if %bet% GTR 1000 echo Bet must be less than $1,000.
if %bet% GTR 1000 pause
if %bet% GTR 1000 goto bet1con
if %bet% GTR %cash% echo You can't afford this bet.
if %bet% GTR %cash% pause
if %bet% GTR %cash% goto bet1con
if %bet% == 0 goto bet1con
goto csngame

:bet2
set stake=mid
cls
if %level% gtr 9 goto bet2con
if %level% lss 10 echo You are not a member of the Bronze League, you must be at least Level 10 to participate.
pause
goto csnstake
	:bet2con
set /a expwin = 50
set /a exploss = 25
cls
echo Cash = $%cash%
echo Bronze League
echo.
echo Enter your bet. Bet must be between $10,000 and $50,000.
set /p bet=
if %bet% == %op1% goto menu
if %bet% LSS 10000 echo Bet must be greater than $10,000.
if %bet% LSS 10000 pause
if %bet% LSS 10000 goto bet2con
if %bet% GTR 50000 echo Bet must be less than $50,000.
if %bet% GTR 50000 pause
if %bet% GTR 50000 goto bet2con
if %bet% GTR %cash% echo You can't afford this bet.
if %bet% GTR %cash% pause
if %bet% GTR %cash% goto bet2con
if %bet% == 0 goto bet2con
goto csngame

:bet3
set stake=high
cls
if %level% gtr 24 goto bet3con
if %level% lss 25 echo You are not a member of the Silver League, you must be at least Level 25 to participate.
pause
goto csnstake
	:bet3con
set /a expwin = 150
set /a exploss = 75
cls
echo Cash = $%cash%
echo Silver League
echo.
echo Enter your bet. Bet must be between $50,000 and $500,000.
set /p bet=
if %bet% == %op1% goto menu
if %bet% LSS 50000 echo Bet must be greater than $50,000. 
if %bet% LSS 50000 pause
if %bet% LSS 50000 goto bet3con
if %bet% GTR 500000 echo Bet must be less than $500,000.
if %bet% GTR 500000 pause
if %bet% GTR 500000 goto bet3con
if %bet% GTR %cash% echo You can't afford this bet.
if %bet% GTR %cash% pause
if %bet% GTR %cash% goto bet3con
if %bet% == 0 goto bet3con
goto csngame

:bet4
set stake=VeryHigh
cls
if %level% gtr 39 goto bet4con
if %level% lss 40 echo You are not a member of the Gold League, you must be at least Level 40 to participate.
pause
goto csnstake
	:bet4con
set /a expwin = 400
set /a exploss = 300
cls
echo Cash = $%cash%
echo.
echo Enter your bet. Bet must be between $500,000 and $20,000,000.
set /p bet=
if %bet% == %op1% goto menu
if %bet% LSS 500000 echo Bet must be greater than $500,000. 
if %bet% LSS 500000 pause
if %bet% LSS 500000 goto bet4con
if %bet% GTR 20000000 echo Bet must be less than $20,000,000.
if %bet% GTR 20000000 pause
if %bet% GTR 20000000 goto bet4con
if %bet% GTR %cash% echo You can't afford this bet.
if %bet% GTR %cash% pause
if %bet% GTR %cash% goto bet4con
if %bet% == 0 goto bet4con
goto csngame

:bet5
set stake=extreme
cls
if %level% gtr 44 goto bet5con
if %level% lss 45 echo You are not a member of the Diamond League, you must be at least Level 45 to participate.
pause
goto csnstake
	:bet5con
set /a expwin = 800
set /a exploss = 400
cls
echo Cash = $%cash%
echo Diamond League
echo.
echo Enter your bet. Bet must be between $20,000,000 and $1,000,000,000.
set /p bet=
if %bet% == %op1% goto menu
if %bet% LSS 20000000 echo Bet must be greater than $20,000,000.
if %bet% LSS 20000000 pause
if %bet% LSS 20000000 goto bet5con
if %bet% GTR 1000000000 echo Bet must be less than $1,000,000,000.
if %bet% GTR 1000000000 pause
if %bet% GTR 1000000000 goto bet5con
if %bet% GTR %cash% echo You can't afford this bet.
if %bet% GTR %cash% pause
if %bet% GTR %cash% goto bet5con
if %bet% == 0 goto bet5con

:csngame
cls
set /a newlevel = %level%
set /a lastgame = 0
set /a played = %played% + 1
set /a payout = %bet%
echo Your bet is %bet%.
echo.
echo Your first card is %playcard1%.
echo Your second card is %playcard2%.
echo.
echo Dealers up card is %dealcard1%
set /a total = %playcard1% + %playcard2%
if %total% == %blackjack% goto csnpblackjack
echo Your total is %total%.
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto csnpcard3
if %action% == 2 goto csndcard
if %action% == %op1% goto menu
if %action% == %op2% goto start
goto csngame
	:csnpcard3
set /a total = %total% + %playcard3%
if %total% == 21 goto csnpblackjack
if %total% GTR 21 goto csnplayerbust
cls
echo You draw a %playcard3%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%    
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto csnpcard4
if %action% == 2 goto csndcard
if %action% == %op1% goto menu
goto csngame
	:csnpcard4
set /a total = %total% + %playcard4%
if %total% == 21 goto csnpblackjack
if %total% GTR 21 goto csnplayerbust
cls
echo You draw a %playcard4%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%    
echo.
echo 1) Hit
echo 2) Stand
set /p action=
if %action% == 1 goto csnpcard5
if %action% == 2 goto csndcard
if %action% == %op1% goto menu
goto csngame
	:csnpcard5
set /a total = %total% + %playcard5%
if %total% == 21 goto csnpblackjack
if %total% GTR 21 goto csnplayerbust
cls
echo You draw a %playcard3%.
echo Your total is now %total%.
echo.
echo Dealers up card is %dealcard1%    
echo.
pause
goto csndcard

:csndcard
cls
echo The dealer will now draw.
ping localhost -n 3 > nul
cls
set /a dtotal = %dealcard1% + %dealcard2%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
set /a dealnum = 2
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto csndcard3
if %dtotal% GTR 16 goto csndstop
if %dtotal% == 21 goto csndblackjack
if %dtotal% GTR 21 goto csndealerbust
	:csndcard3
cls
set /a dtotal = %dtotal% + %dealcard3%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
set /a dealnum = 3
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto csndcard4
if %dtotal% GTR 16 goto csndstop
if %dtotal% == 21 goto csndblackjack
if %dtotal% GTR 21 goto csndealerbust
	:csndcard4
cls
set /a dtotal = %dtotal% + %dealcard4%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
echo Fourth card: %dealcard4%
set /a dealnum = 4
ping localhost -n 3 > nul
if %dtotal% LSS 17 goto csndcard5
if %dtotal% GTR 16 goto csndstop
if %dtotal% == 21 goto csndblackjack
if %dtotal% GTR 21 goto csndealerbust
	:csndcard5
cls
set /a dtotal = %dtotal% + %dealcard5%
echo Dealer's Total: %dtotal%
echo.
echo First card: %dealcard1%
echo Second card: %dealcard2%
echo Third card: %dealcard3%
echo Fourth card: %dealcard4%
echo Fifth card: %dealcard5%
set /a dealnum = 5
ping localhost -n 3 > nul
if %dtotal% == 21 goto csndblackjack
if %dtotal% GTR 21 goto csndealerbust
goto csndstop

:csndstop
if %dtotal% == 21 goto csndblackjack
if %dtotal% GTR 21 goto csndealerbust
echo.
echo Dealer stopped at %dtotal%
echo.
if %dtotal% == %total% echo Push. No winner. %total% - %dtotal%.
if %dtotal% GTR %total% echo Dealer has higher score, %total% - %dtotal%.
if %dtotal% GTR %total% echo Dealer wins.
if %dtotal% GTR %total% echo.
if %dtotal% GTR %total% set /a cash = %cash% - %bet%
if %dtotal% GTR %total% echo You lost $%bet%!
if %dtotal% GTR %total% echo.
if %dtotal% GTR %total% echo You've lost %exploss% experience!
if %dtotal% GTR %total% set /a experience = %experience% - %exploss%
if %dtotal% GTR %total% set /a losses = %losses% + 1
if %dtotal% GTR %total% set /a lostcash = %lostcash% + %bet%
if %dtotal% GTR %total% set /a lastgame = %lastgame% + %bet%
if %dtotal% GTR %total% set /a lastgamemod = 2
if %dtotal% GTR %total% set /a session = %session% - %bet%
if %total% GTR %dtotal% echo Your score is higher, %total% - %dtotal%.
if %total% GTR %dtotal% echo You win $%payout%
if %total% GTR %dtotal% echo.
if %total% GTR %dtotal% echo You've gained %expwin% experience!
if %total% GTR %dtotal% set /a experience = %experience% + %expwin%
if %total% GTR %dtotal% set /a cash = %cash% + %payout%
if %total% GTR %dtotal% set /a wins = %wins% + 1
if %total% GTR %dtotal% set /a earnedcash = %earnedcash% + %payout%
if %total% GTR %dtotal% set /a lastgame = %lastgame% + %bet%
if %total% GTR %dtotal% set /a lastgamemod = 1
if %total% GTR %dtotal% set /a session = %session% + %bet%
if %total% GTR %dtotal% echo.
if %total% GTR %dtotal% echo You won $%payout%!
if %cash% GTR %mostcash% set /a mostcash = %cash%
echo.
pause
set /a gamesplayed = %gamesplayed% + 1
goto csnplayagain

:csnpblackjack
cls
echo %total% Blackjack! You win!
echo.
echo You won $%payout%!
echo.
echo You've gained %expwin% experience!
echo Plus a bonus %expwin% for getting Blackjack!
echo.
set /a expbonus = %expwin% * 2
set /a experience = %experience% + %expbonus%
set /a cash = %cash% + %payout%
set /a wins = %wins% + 1
set /a earnedcash = %earnedcash% + %payout%
set /a lastgame = %lastgame% + %bet%
set /a lastgamemod = 1
set /a session = %session% + %bet%
if %cash% GTR %mostcash% set /a mostcash = %cash%
echo.
pause
set /a gamesplayed = %gamesplayed% + 1
goto csnplayagain

:csndblackjack
echo.
echo Dealer has blackjack. Dealer wins.
echo.
set /a cash = %cash% - %bet%
echo You lost $%bet%.
echo.
echo You've lost %exploss% experience!
echo.
set /a experience = %experience% - %exploss%
set /a losses = %losses% +1
set /a lostcash = %lostcash% + %bet%
set /a lastgame = %lastgame% + %bet%
set /a lastgamemod = 2
set /a session = %session% - %bet%
echo.
pause
set /a gamesplayed = %gamesplayed% + 1
goto csnplayagain

:csnplayerbust
cls
echo Bust! Your total is %total%. Dealer wins!
echo.
set /a cash = %cash% - %bet%
echo You lost $%bet%.
echo.
echo You've lost %exploss% experience!
echo.
set /a experience = %experience% - %exploss%
set /a losses = %losses% +1
set /a lostcash = %lostcash% + %bet%
set /a lastgame = %lastgame% + %bet%
set /a lastgamemod = 2
set /a session = %session% - %bet%
echo.
pause
set /a gamesplayed = %gamesplayed% + 1
goto csnplayagain

:csndealerbust
echo.
echo Dealer has %dtotal%, dealer bust. You win!
echo.
set /a cash = %cash% + %payout%
echo You won $%payout%!
echo.
echo You've gained %expwin% experience!
echo.
set /a experience = %experience% + %expwin%
set /a wins = %wins% + 1
set /a earnedcash = %earnedcash% + %payout%
if %cash% GTR %mostcash% set /a mostcash = %cash%
set /a lastgame = %lastgame% + %bet%
set /a lastgamemod = 1
set /a session = %session% + %bet%
echo.
pause
set /a gamesplayed = %gamesplayed% + 1
goto csnplayagain

:csnplayagain
goto expgainer
	:csnplayagain2
cls
echo Play Again? (Y/N)
set /p pa=
if %pa% == y goto csnsetup
if %pa% == n goto menu
goto csnplayagain2

		REM The lines below will gather the player's total experience, and adjust player level as needed.

:expgainer
if %experience% gtr 68926 set /a newlevel = 50
if %experience% lss 68927 set /a newlevel = 49
if %experience% lss 62586 set /a newlevel = 48
if %experience% lss 56822 set /a newlevel = 47
if %experience% lss 51582 set /a newlevel = 46
if %experience% lss 46819 set /a newlevel = 45
if %experience% lss 42489 set /a newlevel = 44
if %experience% lss 38553 set /a newlevel = 43
if %experience% lss 34975 set /a newlevel = 42
if %experience% lss 31723 set /a newlevel = 41
if %experience% lss 28767 set /a newlevel = 40
if %experience% lss 26080 set /a newlevel = 39
if %experience% lss 23638 set /a newlevel = 38
if %experience% lss 21418 set /a newlevel = 37
if %experience% lss 19400 set /a newlevel = 36
if %experience% lss 17566 set /a newlevel = 35
if %experience% lss 15899 set /a newlevel = 34
if %experience% lss 14384 set /a newlevel = 33
if %experience% lss 13007 set /a newlevel = 32
if %experience% lss 11756 set /a newlevel = 31
if %experience% lss 10619 set /a newlevel = 30
if %experience% lss 9586 set /a newlevel = 29
if %experience% lss 8647 set /a newlevel = 28
if %experience% lss 7794 set /a newlevel = 27
if %experience% lss 7019 set /a newlevel = 26
if %experience% lss 6315 set /a newlevel = 25
if %experience% lss 5675 set /a newlevel = 24
if %experience% lss 5094 set /a newlevel = 23
if %experience% lss 4566 set /a newlevel = 22
if %experience% lss 4086 set /a newlevel = 21
if %experience% lss 3650 set /a newlevel = 20
if %experience% lss 3254 set /a newlevel = 19
if %experience% lss 2894 set /a newlevel = 18
if %experience% lss 2567 set /a newlevel = 17
if %experience% lss 2270 set /a newlevel = 16
if %experience% lss 2000 set /a newlevel = 15
if %experience% lss 1755 set /a newlevel = 14
if %experience% lss 1533 set /a newlevel = 13
if %experience% lss 1332 set /a newlevel = 12
if %experience% lss 1150 set /a newlevel = 11
if %experience% lss 985 set /a newlevel = 10
if %experience% lss 835 set /a newlevel = 9
if %experience% lss 699 set /a newlevel = 8
if %experience% lss 586 set /a newlevel = 7
if %experience% lss 484 set /a newlevel = 6
if %experience% lss 392 set /a newlevel = 5
if %experience% lss 309 set /a newlevel = 4
if %experience% lss 234 set /a newlevel = 3
if %experience% lss 166 set /a newlevel = 2
if %experience% lss 105 set /a newlevel = 1
if %experience% lss 50 set /a newlevel = 0
if %experience% lss 0 set /a experience = 0
if %newlevel% neq %level% goto levelchange
goto csnplayagain2

:levelchange
cls
echo Your level has changed! %level% --) %newlevel%
echo.
pause
set /a level = %newlevel%
goto csnplayagain2

:exit
echo.
echo Thank you for playing! =)
echo.
ping localhost -n 3 > nul

:exit2
