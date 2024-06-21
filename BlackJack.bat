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
set /p cheattype=
if %cheattype% == 1 goto cashmod
if %cheattype% == 2 goto levels
if %cheattype% == 3 goto menu

:levels
cls
echo.
echo WARNING! Unlocking all leagues cannot be undone! Confirm? (Y/N)
set /p levelhack=
if %levelhack% == y goto levelhack
if %levelhack% == n goto menu

:levelhack
cls
set /a level = 10
echo All leagues unlocked. Do not save your game if you wish to keep these.
pause
goto menu2

:cashmod
cls
echo.
echo How much cash do you want? (use "-" to remove money)
set /p money=
set /a cash = %cash% + %money%
echo.
echo Cash modified.
pause
goto menu2

:version
cls
echo.
echo Version %vsn%
pause
goto menu

:command
cls
echo 1) Set Debug Options
echo 2) Reset
echo 3) Change version
echo 4) -Back-
set /p debugcmd=
if %debugcmd% == 1 goto debug
if %debugcmd% == 2 goto boot
if %debugcmd% == 3 goto vchange
if %debugcmd% == 4 goto menu

:vchange
cls
echo Current version is %vsn%. What do you want to change it to?
set /p vsn=
goto menu

:debug
cls
echo Select the debug option to set:
echo 1) Reset the menu command
echo 2) Reset the version command
echo 3) Reset the cheat command
echo 4) Set custom menu command
echo 5) Set custom version command
echo 6) Set custom cheat command
echo 7) -Back-
set /p setcommand=
if %setcommand% == 1 set op1=menu
if %setcommand% == 1 goto menu
if %setcommand% == 2 set op3=version
if %setcommand% == 2 goto menu
if %setcommand% == 3 set op5=cheat
if %setcommand% == 3 goto menu
if %setcommand% == 4 goto custommenu
if %setcommand% == 5 goto customversion
if %setcommand% == 6 goto customcheat
if %setcommand% == 7 goto menu

:custommenu
cls
echo What do you want the menu command to be?
set /p op1=
goto menu

:customversion
cls
echo What do you want the version command to be?
set /p op3=
goto menu

:customcheat
cls
echo What do you want the cheat command to be?
set /p op5=
goto menu

:how
cls
echo ---------------------------------
echo.
echo The aim of Blackjack is to beat the dealer's hand without going over 21.
echo Each player starts with two cards, one of the dealer's cards is hidden until the end.
echo To 'Hit' is to ask for another card. To 'Stand' is to hold your total and end your turn.
echo If you go over 21 you bust, and the dealer wins regardless of the dealer's hand.
echo If you are dealt 21 from the start (Ace & 10), you got a blackjack.
echo Blackjack usually means you win 1.5 the amount of your bet. Depends on the casino.
echo Dealer will hit until his/her cards total 17 or higher.
echo Doubling is like a hit, only the bet is doubled and you only get one more card.
echo Split can be done when you have two of the same card - the pair is split into two hands.
echo Splitting also doubles the bet, because each new hand is worth the original bet.
echo You can only double/split on the first move, or first move of a hand created by a split.
echo You cannot play on two aces after they are split.
echo You can double on a hand resulting from a split, tripling or quadrupling you bet.
echo.
pause
goto menu2

:modes
cls
echo What game mode do you want to play?
echo 1) Classic Blackjack
echo 2) Casino Leagues
echo 3) -Back-
set /p gamemode=
if %gamemode% == 1 goto classic
if %gamemode% == 2 goto league
if %gamemode% == 3 goto menu
goto modes

:classic
cls
set lastgamemod=classic
set /a stake = 50
goto roundstart

:league
cls
echo The leagues are locked and will be unlocked as you progress.
echo Current league is based on your level.
echo.
echo Levels 1-2: Bronze
echo Levels 3-4: Silver
echo Levels 5-6: Gold
echo Levels 7-8: Platinum
echo Levels 9-10: Diamond
echo.
if %level% lss 1 goto bronze
if %level% lss 3 goto bronze
if %level% lss 5 goto silver
if %level% lss 7 goto gold
if %level% lss 9 goto platinum
if %level% geq 9 goto diamond

:bronze
echo Current league is: BRONZE
echo Stake: $100
set /a stake = 100
pause
goto roundstart

:silver
echo Current league is: SILVER
echo Stake: $250
set /a stake = 250
pause
goto roundstart

:gold
echo Current league is: GOLD
echo Stake: $500
set /a stake = 500
pause
goto roundstart

:platinum
echo Current league is: PLATINUM
echo Stake: $750
set /a stake = 750
pause
goto roundstart

:diamond
echo Current league is: DIAMOND
echo Stake: $1000
set /a stake = 1000
pause
goto roundstart

:roundstart
cls
set /a lastgame = 1
set /a bet = 0
if %stake% == 50 goto bet50
if %stake% == 100 goto bet100
if %stake% == 250 goto bet250
if %stake% == 500 goto bet500
if %stake% == 750 goto bet750
if %stake% == 1000 goto bet1000

:bet50
set /a bet = 50
goto game

:bet100
set /a bet = 100
goto game

:bet250
set /a bet = 250
goto game

:bet500
set /a bet = 500
goto game

:bet750
set /a bet = 750
goto game

:bet1000
set /a bet = 1000
goto game

:game
set /a dtotal = 0
set /a total = 0
cls
set /a gamesplayed = %gamesplayed% +1
echo Dealing cards...
ping localhost -n 2 > nul
echo.
echo Dealer's card:
echo +-----+
echo ^     ^
echo ^     ^
echo ^  *  ^
echo ^     ^
echo +-----+
ping localhost -n 2 > nul
echo.
goto player1

:player1
set /a draw = %random% %% 10 + 1
set /a total = %total% + %draw%
goto player1output

:player1output
echo Your card is: %draw%
echo.
if %total% lss 21 goto player1choice
if %total% equ 21 goto dealer
if %total% gtr 21 goto playerbust

:player1choice
echo Total = %total%
echo.
echo 1) Hit
echo 2) Stand
echo 3) Double
set /p choice=
if %choice% == 1 goto player1
if %choice% == 2 goto dealer
if %choice% == 3 goto playerdouble
goto player1choice

:playerbust
cls
echo You busted!
set /a losses = %losses% + 1
set /a cash = %cash% - %bet%
set /a lostcash = %lostcash% + %bet%
echo Total losses: %losses%
echo.
echo Cash = $%cash%
pause
goto menu2

:playerdouble
set /a bet = %bet% * 2
set /a draw = %random% %% 10 + 1
set /a total = %total% + %draw%
echo Your card is: %draw%
if %total% lss 21 goto dealer
if %total% equ 21 goto dealer
if %total% gtr 21 goto playerbust

:dealer
cls
set /a draw = %random% %% 10 + 1
set /a dtotal = %dtotal% + %draw%
echo Dealer's card is: %draw%
if %dtotal% lss 17 goto dealer
if %dtotal% equ 17 goto wincondition
if %dtotal% gtr 17 goto wincondition

:wincondition
if %dtotal% equ 21 goto dealerblackjack
if %dtotal% gtr 21 goto dealerbust
if %dtotal% lss %total% goto playerwin
if %dtotal% equ %total% goto tie
if %dtotal% gtr %total% goto playerbust

:dealerbust
cls
echo The dealer busted!
set /a wins = %wins% + 1
set /a cash = %cash% + %bet%
set /a woncash = %woncash% + %bet%
echo Total wins: %wins%
echo.
echo Cash = $%cash%
pause
goto menu2

:dealerblackjack
cls
echo The dealer hit blackjack!
set /a losses = %losses% + 1
set /a cash = %cash% - %bet%
set /a lostcash = %lostcash% + %bet%
echo Total losses: %losses%
echo.
echo Cash = $%cash%
pause
goto menu2

:playerwin
cls
echo You win!
set /a wins = %wins% + 1
set /a cash = %cash% + %bet%
set /a woncash = %woncash% + %bet%
echo Total wins: %wins%
echo.
echo Cash = $%cash%
pause
goto menu2

:tie
cls
echo It's a tie!
pause
goto menu2
