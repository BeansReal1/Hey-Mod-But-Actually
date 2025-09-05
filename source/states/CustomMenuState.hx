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


class CustomMenuState extends MusicBeatState {
    var myText:FlxText;
    var selectText:FlxText;
    var playerText:FlxText;
    var oponentText:FlxText;

    var playerIndex:Int = -1;
    var oponentIndex:Int = -1;

    var selectString:String;

    var characterMoveValue:Int = 20;

    var selectFlag:Bool;
    var playerFlag:Bool;
    var oponentFlag:Bool;

    var menuItems:FlxTypedGroup<FlxSprite>;
    var playerSelected:FlxSprite = null;
    var oponentSelected:FlxSprite = null;
    var cursor:FlxSprite;
    var selectedItem:FlxSprite;
    public static var curSelected:Int = 0;

    var characters:Array<String> = [
		'beans',
		'vam',
		'yabo',
		'jay',
        'cierra'
	];

    override function create() {
        super.create();

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
        add(cursor);
        add(myText);
        add(selectText);
        add(playerText);
        add(oponentText);

        cursor.x = 0;
        cursor.y = 0;

        menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        for (num => character in characters) {
            createCharacter(100 + num*300, 50, FlxColor.WHITE, character);
        }

        positionMenuItems(false);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        backOutCheck();
        selectCheck();
        textDisplay();
        selectSong();
        cursorMovement();
        myText.y += 10 * elapsed;

    }

    function wrapFloat(value:Float, min:Float, max:Float):Float {
    var range = max - min;
    return ((value - min) % range + range) % range + min;
}

    function positionMenuItems(animated:Bool = false) {
        var itemCount:Int = menuItems.length;
        var screenWidth:Float = FlxG.width;
        var spacing:Float = screenWidth / itemCount;
        var centerX:Float = screenWidth / 2;

        for (i in 0...itemCount) {
            var item = menuItems.members[i];

            // relative index
            var offset = i - curSelected;
            if (offset > itemCount / 2) offset -= itemCount;
            if (offset < -itemCount / 2) offset += itemCount;

            var targetX = centerX + offset * spacing;
            var finalX = targetX - item.width / 2;
            var finalY = FlxG.height / 2 - item.height / 2;

            var distance = Math.abs(item.x - finalX);

            if (animated && distance < screenWidth / 2) {
                FlxTween.tween(item, {x: finalX, y: finalY}, 0.3, {ease: FlxEase.quadOut});
            } else {
                item.x = finalX;
                item.y = finalY;
            }

            item.alpha = (i == curSelected) ? 0.5 : 1;
        }
    }


    private function cursorMovement() {
        cursor.x = FlxG.width / 2;
        cursor.y = FlxG.height / 2;

    }

    private function selectSong() {
        if (playerFlag && oponentFlag) {
            // Start the song or whatever depending on player and oponent
            playerFlag = false;
            oponentFlag = false;
            playerSelected = null;
            oponentSelected = null;
            playerIndex = -1;
            oponentIndex = -1;
            return;
        }
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

			MusicBeatState.switchState(new MainMenuState());
		}
    }

    private function selectCheck() {

        if (controls.UI_RIGHT_P) {
            changeItem(1);
        } else if (controls.UI_LEFT_P) {
            changeItem(-1);
        } else if (controls.ACCEPT) {
            selectCharacter(menuItems.members[curSelected]);
        }


    }

    private function selectCharacter(char:FlxSprite) {
        if (char != playerSelected && !playerFlag) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            playerSelected = char;
            playerFlag = true;
            playerIndex = curSelected;
        }

        else if (char != playerSelected && playerFlag) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            oponentSelected = char;
            oponentFlag = true;
            oponentIndex = curSelected;
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
        

        curSelected = FlxMath.wrap(curSelected + change, 0, characters.length - 1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
        selectedItem = menuItems.members[curSelected];
        positionMenuItems(false);

        for (item in menuItems) {

            if (item == selectedItem) {
                item.alpha = 0.5;
            } else {
                item.alpha = 1;
            }
        }
    }

    override function destroy() {
        super.destroy();
    }
}