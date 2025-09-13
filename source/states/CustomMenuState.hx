package states;

import flixel.FlxState;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import flixel.text.FlxText;

import flixel.FlxG;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.group.FlxGroup;
import flixel.graphics.FlxGraphic;

import objects.MenuItem;
import objects.MenuCharacter;

import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import backend.StageData;

import openfl.display.BlendMode;

//import states.menu.QuickPlaySong;
//import states.menu.SessionEntry;
import backend.Song;
import haxe.Json;
import lime.utils.Assets;
import backend.Highscore;
import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;
//import states.menu.SongEntry;


class CustomMenuState extends MusicBeatState {
    var myText:FlxText;
    var selectText:FlxText;
    var playerText:FlxText;
    var oponentText:FlxText;

    var playerIndex:Int = -1;
    var oponentIndex:Int = -1;

    var renderTweenTime:Float = 0.3;

    var selectString:String;

    var characterMoveValue:Int = 20;

    var selectFlag:Bool;
    var playerFlag:Bool;
    var oponentFlag:Bool;

    var menuItems:FlxTypedGroup<FlxSprite>;
    var renderItemsPlayer:FlxTypedGroup<FlxSprite>;
    var renderItemsOponent:FlxTypedGroup<FlxSprite>;
    var playerSelected:FlxSprite = null;
    var oponentSelected:FlxSprite = null;
    var hugeFuckingSquare:FlxSprite = null;
    var cursor:FlxSprite;
    var selectedItem:FlxSprite;
    public static var curSelected:Int = 0;

    var playerRenderx:Float = 20;
    var playerRendery:Float = 20;
    var oponentRenderx:Float = FlxG.width - 100;
    var oponentRendery:Float = 20;

    var characters:Array<String> = [
		'beans',
		'vam',
		'yabo',
		'jay',
        'cierra'
	];

    var beansOponents:Array<String> = [
        'vam'
    ];

    var vamOponents:Array<String> = [
        'beans'
    ];

    var yaboOponents:Array<String> = [
        'jay'
    ];

    var jayOponents:Array<String> = [
        'yabo'
    ];

    var cierraOponents:Array<String> = [];

    var avaliableOponents:Array<String> = [];

    override function create() {
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

        super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('charSelect/background'));
        bg.screenCenter();
        bg.scale.set(0.70, 0.70);
		add(bg);

		var smoke:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('charSelect/smoke'));
        smoke.screenCenter();
        smoke.scale.set(0.70, 0.70);
		add(smoke);

		var grid:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('charSelect/gridHardLight'));
        grid.screenCenter();
        grid.blend = BlendMode.HARDLIGHT;
        grid.scale.set(0.70, 0.70);
		add(grid);

        var halftoneBottom:FlxSprite = new FlxSprite(-80);
        halftoneBottom.frames = Paths.getSparrowAtlas('charSelect/halftoneBottomAdd');
		halftoneBottom.animation.addByPrefix('loop', 'halftoneBottom', 24, true);
        halftoneBottom.scale.set(0.70, 0.70);
        halftoneBottom.screenCenter();
		halftoneBottom.animation.play('loop');
        add(halftoneBottom);

        var halftoneTop:FlxSprite = new FlxSprite(-80);
        halftoneTop.frames = Paths.getSparrowAtlas('charSelect/halftoneTopAdd');
		halftoneTop.animation.addByPrefix('loop', 'halftoneTop', 24, true);
        halftoneTop.scale.set(0.70, 0.70);
        halftoneTop.screenCenter();
		halftoneTop.animation.play('loop');
        halftoneTop.flipX = true;
        add(halftoneTop);

        var whiteCircle:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('charSelect/whiteCircle'));
        whiteCircle.screenCenter();
        whiteCircle.scale.set(0.70, 0.70);
		add(whiteCircle);

        var framing:FlxSprite = new FlxSprite(-80);
        framing.frames = Paths.getSparrowAtlas('charSelect/framingMultiply');
		framing.animation.addByPrefix('loop', 'thing loop', 24, true);
        framing.blend = BlendMode.MULTIPLY;
        framing.scale.set(0.70, 0.70);
        framing.screenCenter();
		framing.animation.play('loop');
        add(framing);

        /* later on you do this because you know the render code better, have it so that the VS image appears over the renders  ok? ok */
        // hey I did it ok I fucking did it yeah ok
        
        var VS:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('charSelect/VS'));
        VS.screenCenter();
        VS.scale.set(0.70, 0.70);
		

        myText = new FlxText(100, 100, 300, "I'm a custom menu, Im cumming ohhhhh");
        selectText = new FlxText(500, 500, 300, "Selected: ");
        playerText = new FlxText(200, 500, 300, "Player: ");
        oponentText = new FlxText(800, 500, 300, "Oponent: ");
        cursor = new FlxSprite();
        cursor.makeGraphic(10,10,FlxColor.GREEN);

        selectText.size = 40;
        myText.size = 40;
        oponentText.size = 30;
        playerText.size = 30;
        selectString = "";
        selectFlag = false;
        playerFlag = false;
        oponentFlag = false;
        
        add(myText);
        add(selectText);
        add(playerText);
        add(oponentText);

        cursor.x = 0;
        cursor.y = 0;

        menuItems = new FlxTypedGroup<FlxSprite>();
        renderItemsPlayer = new FlxTypedGroup<FlxSprite>();
        renderItemsOponent = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
        add(renderItemsPlayer);
        add(renderItemsOponent);

        for (num => character in characters) {
            createCharacter(100 + num*300, 50, FlxColor.WHITE, character);
            createRenderPlayer(0, playerRendery, character);
            createRenderOponent(FlxG.width, oponentRendery, character);
        }

        positionMenuItems(false);
        add(cursor);
        add(VS);

        createHugeFuckingSquare();
        add(hugeFuckingSquare);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        backOutCheck();
        selectCheck();
        textDisplay();
        hugeFuckingSquareChecks();
        cursorMovement();
        selectedVisualManagement();
        getOponents();
        positionRender();
        myText.y += 10 * elapsed;

    }

    function createHugeFuckingSquare() {
        hugeFuckingSquare = new FlxSprite();
        hugeFuckingSquare.makeGraphic(FlxG.width,FlxG.height, FlxColor.BLACK);
        hugeFuckingSquare.alpha = 0;
    }

    function getOponents() {

        if (playerFlag && !oponentFlag) {
            switch(characters[playerIndex]) {
                case 'beans':
                    for (oponent in beansOponents) {
                        avaliableOponents.push(oponent);
                    }
                case 'vam':
                    for (oponent in vamOponents) {
                        avaliableOponents.push(oponent);
                    }
                    
                case 'yabo':
                    for (oponent in yaboOponents) {
                        avaliableOponents.push(oponent);
                    }
                    
                case 'jay':
                    for (oponent in jayOponents) {
                        avaliableOponents.push(oponent);
                    }
                case 'cierra':
                    for (oponent in cierraOponents) {
                        avaliableOponents.push(oponent);
                    }
                default:
                    avaliableOponents = [];
            }
        } else if (!playerFlag) {
            avaliableOponents = [];
        }
    }


    function enterSong(_name:String){
        persistentUpdate = false;
        var songLowercase:String = Paths.formatToSongPath(_name);
        var poop:String = Highscore.formatSong(songLowercase, 1);

        Song.loadFromJson(poop, songLowercase);
        PlayState.isStoryMode = false;
        PlayState.storyDifficulty = 1;
        Paths.freeGraphicsFromMemory();

        @:privateAccess
        if(PlayState._lastLoadedModDirectory != Mods.currentModDirectory)
        {
            trace('CHANGED MOD DIRECTORY, RELOADING STUFF');
            Paths.freeGraphicsFromMemory();
        }
        LoadingState.prepareToSong();
        LoadingState.loadAndSwitchState(new PlayState());
        #if !SHOW_LOADING_SCREEN FlxG.sound.music.stop(); #end

        #if (MODS_ALLOWED && DISCORD_ALLOWED)
        DiscordClient.loadModRPC();
        #end
    }



    function wrapFloat(value:Float, min:Float, max:Float):Float {
    var range = max - min;
    return ((value - min) % range + range) % range + min;
    }



    function positionMenuItems(animated:Bool = false, totalDuration:Float = 0.2) {
        var itemCount:Int = menuItems.length;
        var screenWidth:Float = FlxG.width;
        var screenHeight:Float = FlxG.height;

        var spacing:Float = screenWidth / itemCount;
        var centerX:Float = screenWidth / 2;

        var exitDuration:Float = 0.07;
        var entryDuration:Float = totalDuration - exitDuration;

        for (i in 0...itemCount) {
            var item = menuItems.members[i];


            var offset = i - curSelected;
            if (offset > itemCount / 2) offset -= itemCount;
            if (offset < -itemCount / 2) offset += itemCount;

            var targetX = centerX + offset * spacing;
            var finalX = targetX - item.width / 2;
            var baseY = screenHeight - item.height / 2;
            var finalY = baseY - (offset == 0 ? 40 : 0);

            if (animated) {
                var wrapThreshold = screenWidth * 0.6;
                var isWrapping = Math.abs(item.x - finalX) > wrapThreshold;
                var comingFromLeft = finalX < item.x;

                if (isWrapping) {

                    var exitX = comingFromLeft ? screenWidth + item.width : -item.width;
                    FlxTween.tween(item, {x: exitX}, exitDuration, {
                        ease: FlxEase.quadIn,
                        onComplete: function(_) {

                            item.x = comingFromLeft ? -item.width : screenWidth + item.width;
                            item.y = finalY;


                            FlxTween.tween(item, {x: finalX, y: finalY}, entryDuration);
                        }
                    });
                } else {

                    FlxTween.tween(item, {x: finalX, y: finalY}, totalDuration);
                }
            } else {
                item.x = finalX;
                item.y = finalY;
            }
        }
    }

    private function selectedVisualManagement() {
        var i:Int = 0;
        for (item in menuItems) {

            if(playerIndex == i || oponentIndex == i || (!avaliableOponents.contains(characters[i]) && playerFlag)) {
                item.alpha = 0.5;
            } else {
                item.alpha = 1;
            }
            i += 1;

        }
        
    }

    private function cursorMovement() {
        cursor.x = FlxG.width / 2 - cursor.width/2;
        cursor.y = 530;

    }

    private function selectSong() {

            // Start the song or whatever depending on player and oponent

            if (characters[playerIndex] == 'beans') {
                if (characters[oponentIndex] == 'vam') {
                    enterSong("noli");
                }
            }

            if (characters[playerIndex] == 'vam') {
                if (characters[oponentIndex] == 'beans') {
                    enterSong("say-my-name");
                }
            }

            if (characters[playerIndex] == 'yabo') {
                if (characters[oponentIndex] == 'jay') {
                    enterSong("sacrifice");
                }
            }

            if (characters[playerIndex] == 'jay') {
                if (characters[oponentIndex] == 'yabo') {
                    enterSong("murder-dance");
                }
            }


            playerFlag = false;
            oponentFlag = false;
            playerSelected = null;
            oponentSelected = null;
            playerIndex = -1;
            oponentIndex = -1;
            return;

    }

    private function textDisplay() {
        selectText.text = "Selected: " + characters[curSelected];

        if (playerIndex != -1) {
            playerText.text = "Player: " + characters[playerIndex];
        } else {
            playerText.text = "Player: none";
        }

        if (oponentIndex != -1) {
            oponentText.text = "Oponent: " + characters[oponentIndex];
        } else {
            oponentText.text = "Oponent: none";
        }
    }

    private function backOutCheck() {
        if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
            if (playerFlag && !oponentFlag) {
                playerSelected = null;
                playerIndex = -1;
                playerFlag = false;
            } else if (oponentFlag) {
                oponentSelected = null;
                oponentIndex = -1;
                oponentFlag = false;
            } else {
                MusicBeatState.switchState(new MainMenuState());
            }
			
		}
    }

    private function hugeFuckingSquareChecks() {
        if (playerFlag && oponentFlag) {
            hugeFuckingSquare.alpha = 0.5;
        } else {
            hugeFuckingSquare.alpha = 0;
        }
    }

    private function selectCheck() {

        if (controls.UI_RIGHT_P && !(playerFlag && oponentFlag)) {
            changeItem(1);
        } else if (controls.UI_LEFT_P && !(playerFlag && oponentFlag)) {
            changeItem(-1);
        } else if (controls.ACCEPT) {
            if (playerFlag && oponentFlag) {
                selectSong();
            } else {
                selectCharacter(menuItems.members[curSelected]);
            }
            
        }


    }

    private function selectCharacter(char:FlxSprite) {

        

        if (char != playerSelected && !playerFlag) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            playerSelected = char;
            playerFlag = true;
            playerIndex = curSelected;
        }

        else if (char != playerSelected && playerFlag && avaliableOponents.contains(characters[curSelected])) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            oponentSelected = char;
            oponentFlag = true;
            oponentIndex = curSelected;
        }
        
    }

    private function createRenderPlayer(x:Float,y:Float,character:String) {
        var color:FlxColor;
        switch(character) {
            case 'beans':
                color = FlxColor.MAGENTA;
            case 'vam':
                color = FlxColor.PURPLE;
            case 'yabo':
                color = FlxColor.RED;
            case 'jay':
                color = FlxColor.BLUE;
            case 'cierra':
                color = FlxColor.PINK;
            default:
                color = FlxColor.WHITE;
        }



        var square:FlxSprite = new FlxSprite();
        square.makeGraphic(200,200,color);
        square.x = x - square.width;
        square.y = y;
        renderItemsPlayer.add(square);

    }

    private function createRenderOponent(x:Float,y:Float,character:String) {
        var color:FlxColor;
        switch(character) {
            case 'beans':
                color = FlxColor.MAGENTA;
            case 'vam':
                color = FlxColor.PURPLE;
            case 'yabo':
                color = FlxColor.RED;
            case 'jay':
                color = FlxColor.BLUE;
            case 'cierra':
                color = FlxColor.PINK;
            default:
                color = FlxColor.WHITE;
        }

        

        var square:FlxSprite = new FlxSprite();
        square.makeGraphic(200,200,color);
        x = FlxG.width + square.width;
        square.x = x;
        square.y = y;
        renderItemsOponent.add(square);

    }

    private function positionRender() {
        if (!playerFlag && !oponentFlag) {
            var i:Int = 0;
            for (item in renderItemsPlayer) {
                renderItemsOponent.members[i].visible = false;
                if (i == curSelected) {
                    item.visible = true;
                    if (item.x <= 0 - item.width) {
                        FlxTween.tween(item, {x: playerRenderx, y: playerRendery}, renderTweenTime, {type: FlxTween.ONESHOT, ease: FlxEase.cubeOut});
                    }
                    
                } else {
                    item.visible = false;
                    item.x = 0 - item.width;
                }
                i += 1;
            }
        }

        else if (playerFlag && !oponentFlag) {
            var j:Int = 0;
            renderItemsPlayer.members[playerIndex].visible = true;
            for (item in renderItemsOponent) {
                if (j == curSelected) {
                    item.visible = true;
                    if (item.x >= FlxG.width + item.width) {
                        FlxTween.tween(item, {x: oponentRenderx - item.width/2 - 20, y: oponentRendery}, renderTweenTime, {type: FlxTween.ONESHOT, ease: FlxEase.cubeOut});
                    }
                    
                } else {
                    item.visible = false;
                    item.x = FlxG.width + item.width;
                }

                if (j != playerIndex) {
                    renderItemsPlayer.members[j].visible = false;
                    renderItemsPlayer.members[j].x = 0 - renderItemsPlayer.members[j].width;
                }
                j += 1;
            }
        }

        else {
            renderItemsPlayer.members[playerIndex].visible = true;
            renderItemsOponent.members[oponentIndex].visible = true;

            var k:Int = 0;
            for (item in renderItemsPlayer) {
                if (k != playerIndex) {
                    item.visible = false;
                    item.x = 0 - item.width;
                }

                if (k != oponentIndex) {
                    renderItemsOponent.members[k].visible = false;
                    renderItemsOponent.members[k].x = FlxG.width + renderItemsOponent.members[k].width;
                }
                k += 1;
            }
        }
    }

    private function createCharacter(x:Int, y:Int, color:FlxColor, character:String) {

        switch(character) {
            case 'beans':
                color = FlxColor.MAGENTA;
            case 'vam':
                color = FlxColor.PURPLE;
            case 'yabo':
                color = FlxColor.RED;
            case 'jay':
                color = FlxColor.BLUE;
            case 'cierra':
                color = FlxColor.PINK;
            default:
                color = FlxColor.WHITE;
        }

        var square:FlxSprite = new FlxSprite();
        square.makeGraphic(200,200,color);
        square.x = x;
        square.y = y;
        menuItems.add(square);
    }

    function changeItem(change:Int) {
        var selectedOffsetY:Float = 30;

        curSelected = FlxMath.wrap(curSelected + change, 0, characters.length - 1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
        selectedItem = menuItems.members[curSelected];
        positionMenuItems(true);

        var i:Int = 0;
        for (item in menuItems) {


            if(playerIndex == i || oponentIndex == i || !avaliableOponents.contains(characters[i])) {
                item.alpha = 0.5;
            } else {
                item.alpha = 1;
            }
            i += 1;

        }
    }

    override function destroy() {
        super.destroy();
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
    }
}