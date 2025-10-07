package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import flixel.addons.display.FlxTiledSprite; // ??? idk LOL
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween; // might need these two as well 
import flixel.FlxG; // and this too
import flixel.FlxSprite; // actually why dont we have this one already either

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0.4'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	var allowMouse:Bool = false; //Turn this off to block mouse movement in menus
	var inTitle:Bool = true;

	var selectBar:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var leftItem:FlxSprite;
	var rightItem:FlxSprite;

	var arcadeButtons:FlxSprite;
	var arcadeStick:FlxSprite;

	// im just sorry ok im trying  all the looping shit is under this

	var halftoneBlue:FlxTiledSprite;
	var cityBack:FlxTiledSprite;
	var cityMid:FlxTiledSprite;
	var water:FlxSprite;
	var cityFrontAndReflection:FlxTiledSprite;

	var cameraZoom:Float = 1.5;

	//Centered/Text options
	var optionShit:Array<String> = [

		// later switch custom to play and options to settings because thats what the files are called or you can just change the file name to custom and options instead

		'custom',
		// 'freeplay',
		'options',
		// #if MODS_ALLOWED 'mods', #end
		'credits'
	];

	var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var rightOption:String = 'options';

	var heyLogo:FlxSprite;

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var itemPos:Array<Array<Int>> = [];

	var yScroll:Float = 0.05;
	var curY:Float;

	static var showOutdatedWarning:Bool = true;
	override function create()
	{
		leftOption = null;
		rightOption = null;
		super.create();

		//Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Arcade", null);
		#end

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menu_bg_arcade'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		//bg.setGraphicSize(Std.int(bg.width * 0.75));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var screenBackdrop:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('arcadeMenu/arcadeScreen/screenBackdrop'));
        screenBackdrop.scale.set(0.80, 0.80);
		screenBackdrop.scrollFactor.set(0, yScroll);
        screenBackdrop.screenCenter();
		screenBackdrop.y = 0;
        add(screenBackdrop);


		// i have no clue what im doing BUT i was told FlxTiledSprite can loop things so bear with me

		halftoneBlue = new FlxTiledSprite(Paths.image('arcadeMenu/arcadeScreen/halftoneBlue'), 475, 200, true, false);
		halftoneBlue.scale.set(0.80, 0.80);
		halftoneBlue.scrollFactor.set(0, yScroll);
        halftoneBlue.screenCenter();
        add(halftoneBlue);

		// where the fuck is the halftone bruh why don't i see it when i compile the build what fuckin ever

		cityBack = new FlxTiledSprite(Paths.image('arcadeMenu/arcadeScreen/cityBack'), 475, 200, true, false);
		cityBack.scale.set(0.80, 0.80);
		cityBack.scrollFactor.set(0, yScroll);
        cityBack.screenCenter();
		cityBack.x = 400;
		cityBack.y = 700;
        add(cityBack);

		cityMid = new FlxTiledSprite(Paths.image('arcadeMenu/arcadeScreen/cityMid'), 475, 200, true, false);
		cityMid.scale.set(0.80, 0.80);
		cityMid.scrollFactor.set(0, yScroll);
        cityMid.screenCenter();
		cityMid.x = 400;
		cityMid.y = 700;
        add(cityMid);

		water = new FlxSprite(-80);
		water.makeGraphic(510, 200, FlxColor.fromString("0xABAFC2"));
        water.scale.set(0.80, 0.80);
		water.scrollFactor.set(0, yScroll);
        water.screenCenter();
		water.y = 880;
        add(water);

		cityFrontAndReflection = new FlxTiledSprite(Paths.image('arcadeMenu/arcadeScreen/cityFrontAndReflection'), 475, 625, true, false);
		cityFrontAndReflection.scale.set(0.80, 0.80);
		cityFrontAndReflection.scrollFactor.set(0, yScroll);
        cityFrontAndReflection.screenCenter();
		cityFrontAndReflection.x = 400;
		cityFrontAndReflection.y = 678;
        add(cityFrontAndReflection);

		selectBar = new FlxSprite(-80);
        selectBar.frames = Paths.getSparrowAtlas('arcadeMenu/arcadeScreen/selectBar');
        selectBar.scale.set(0.80, 0.80);
		selectBar.scrollFactor.set(0, yScroll);
		selectBar.animation.addByPrefix('idle', 'selectBar idle', 24, true);
		selectBar.animation.addByPrefix('select', 'selectBar enter', 24, true);
		//selectBar.animation.onFinish.add(barAnim);

        selectBar.screenCenter();
		selectBar.animation.play('idle');
        add(selectBar);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		heyLogo = new FlxSprite(-80).loadGraphic(Paths.image('arcadeMenu/heyLogo'));
        heyLogo.scale.set(0.80, 0.80);
		heyLogo.scrollFactor.set(0, yScroll);
        heyLogo.screenCenter();
		heyLogo.y = 195;
        add(heyLogo);

		// ok screen stuff over time for the rest of the bg eto bleeehhh

		var arcadeMachine:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('arcadeMenu/arcadeMachine'));
        arcadeMachine.scale.set(0.80, 0.80);
		arcadeMachine.scrollFactor.set(0, yScroll);
        arcadeMachine.screenCenter();
		arcadeMachine.y = -250;
        add(arcadeMachine);

		arcadeButtons = new FlxSprite(-80);
        arcadeButtons.frames = Paths.getSparrowAtlas('arcadeMenu/arcadeButtons');
        arcadeButtons.scale.set(0.80, 0.80);
		arcadeButtons.scrollFactor.set(0, yScroll);
		arcadeButtons.animation.addByPrefix('idle', 'arcadeButtons idle', 24, true);
		arcadeButtons.animation.addByPrefix('select', 'arcadeButtons select', 24, true);
		arcadeButtons.animation.addByPrefix('back', 'arcadeButtons back', 24, true);
		arcadeButtons.animation.addByPrefix('start', 'arcadeButtons start', 24, true);
		arcadeButtons.x = 560;
		arcadeButtons.y = 540;
		arcadeButtons.animation.play('idle');
        add(arcadeButtons);

		arcadeStick = new FlxSprite(-80);
        arcadeStick.frames = Paths.getSparrowAtlas('arcadeMenu/arcadeStick');
        arcadeStick.scale.set(0.80, 0.80);
		arcadeStick.scrollFactor.set(0, yScroll);
		arcadeStick.animation.addByPrefix('idle', 'arcadeStick idle', 24, true);
		arcadeStick.animation.addByPrefix('left', 'arcadeStick left', 24, true);
		arcadeStick.animation.addByPrefix('up', 'arcadeStick up', 24, true);
		arcadeStick.animation.addByPrefix('right', 'arcadeStick right', 24, true);
		arcadeStick.animation.addByPrefix('down', 'arcadeStick down', 24, true);
		arcadeStick.x = 430;
		arcadeStick.y = 480;
		arcadeStick.animation.play('idle');
        add(arcadeStick);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		for (num => option in optionShit)
		{
			var separation:Int = 30;
			var verticalOffset:Int = 325;
			var itemx = 0;
			var itemy = (num * separation) + verticalOffset; 
			var pos:Array<Int> = [];
			pos.push(itemx);
			pos.push(itemy); // this is a surprise tool that will help us later (tweens)
			itemPos.push(pos);
			var item:FlxSprite = createMenuItem(option, itemx, itemy);
			item.scrollFactor.set(0, yScroll);

			item.y += (4 - optionShit.length) * 70; // Offsets for when you have anything other than 4 items
			item.screenCenter(X);
		}

		if (leftOption != null)
			leftItem = createMenuItem(leftOption, 60, 490);
		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, FlxG.width - 60, 490);
			rightItem.x -= rightItem.width;
		}

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		#if CHECK_FOR_UPDATES
		if (showOutdatedWarning && ClientPrefs.data.checkForUpdates && substates.OutdatedSubState.updateVersion != psychEngineVersion) {
			persistentUpdate = false;
			showOutdatedWarning = false;
			openSubState(new substates.OutdatedSubState());
		}
		#end

		FlxG.camera.zoom = 1;

		FlxG.camera.follow(camFollow, null, 0.15);
		var titleStart:Bool = true;
		if (titleStart) {
			sendMenuToHell();
			barVisibility(false);
		} else {
			initMenu();
		}
		curY = itemPos[0][1];
		//changeItem(0, false);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('arcadeMenu/arcadeScreen/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.scale.set(0.8, 0.8);
		menuItem.updateHitbox();
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	function sendMenuToHell() {
		for (item in menuItems) {
			item.y = FlxG.height;
		}
	}

	function menuVisibility(visibility:Bool) {
		for (item in menuItems) {
			item.visible = visibility;
		}
	}

	function tweenMenu(init:Bool) {
		var tweenDuration:Float = 0.5;
		if (init) {
			var i:Int = 0;
			for (item in menuItems) {
				FlxTween.tween(item, {x: item.x, y: itemPos[i][1]}, tweenDuration, {ease: FlxEase.quartOut});
				i++;
			}
		} else {
			var i:Int = 0;
			var offset:Int = 500;
			for (item in menuItems) {
				FlxTween.tween(item, {x: item.x, y: item.y + offset}, tweenDuration, {ease: FlxEase.quartIn});
				i++;
			}
		}
	}

	function barMovement(selectedItem:FlxSprite) {
		var tweenDuration:Float = 0.2;
		var offset:Float = 5;
		FlxTween.tween(selectBar, {x: selectBar.x, y: selectedItem.y - offset}, tweenDuration, {ease: FlxEase.quintInOut});
	}

	function barAnim() {
		selectBar.animation.play("idle");
	}

	function barAnimSelect() {
		var barOffset:Float = 5;

		barVisibility(true);
		selectBar.y = curY - barOffset;
		selectBar.animation.play('select');
		haxe.Timer.delay(() -> barAnim(), 100);
		
	}

	function barVisibility(v:Bool) {
		selectBar.visible = v;
	}





	function initMenu() {
		
		
		//menuVisibility(true);
		tweenMenu(true); // we tweening shit now ok
		
		selectBar.animation.play('select');
		
		FlxG.sound.play(Paths.sound('confirmMenu'));
		arcadeButtons.animation.play('idle');
		inTitle = false;
		haxe.Timer.delay(() -> barAnimSelect(), 400);
		
		
	}

	function unInitMenu() {
		
		//menuVisibility(false);
		tweenMenu(false); 
		barVisibility(false);
		FlxG.sound.play(Paths.sound('cancelMenu'));
		arcadeButtons.animation.play('idle');
		inTitle = true;
	}

	function logoShit(t: FlxTween):Void {
		FlxTween.tween(heyLogo.scale, {x:0.55, y:0.55}, 0.5, {ease: FlxEase.quartOut} );
		FlxTween.tween(heyLogo, { x: heyLogo.x, y: 125 }, {ease: FlxEase.quartOut});
	}

	function logoShit2(t: FlxTween):Void {
		FlxTween.tween(heyLogo.scale, {x:0.8, y:0.8}, 0.5, {ease: FlxEase.quartOut} );
		FlxTween.tween(heyLogo, { x: heyLogo.x, y: heyLogo.y }, {ease: FlxEase.quartOut});
	}

	function titleChecks() {
		var cameraTweenDuration:Float = 1;
		if (controls.ACCEPT && inTitle) {
			FlxTween.tween(FlxG.camera, {zoom: cameraZoom}, cameraTweenDuration, {ease: FlxEase.quartOut});
			arcadeButtons.animation.play('start');

			haxe.Timer.delay(() -> initMenu(), 100);

			// screen bullshit

			FlxTween.tween(heyLogo.scale, {x:0.6, y:0.6}, 0.5, {ease: FlxEase.quartIn} );
			FlxTween.tween(heyLogo, { x: heyLogo.x, y: heyLogo.y }, 0.5,{ease: FlxEase.quartIn, onComplete: logoShit});

			FlxTween.tween(halftoneBlue, { x: 400, y: 400 }, {ease: FlxEase.quartOut});
			FlxTween.tween(cityBack, { x: 400, y: 200 }, {ease: FlxEase.quartOut});
			FlxTween.tween(cityMid, { x: 400, y: 200 }, {ease: FlxEase.quartOut});
			FlxTween.tween(water, { x: water.x, y: 380 }, {ease: FlxEase.quartOut});
			FlxTween.tween(cityFrontAndReflection, { x: 400, y: 178 }, {ease: FlxEase.quartOut});

		}

		if (controls.BACK && !inTitle) {
			FlxTween.tween(FlxG.camera, {zoom: 1}, cameraTweenDuration, {ease: FlxEase.quartOut});
			arcadeButtons.animation.play('back');
			haxe.Timer.delay(() -> unInitMenu(), 100);

			// screen bullshit
			FlxTween.tween(heyLogo.scale, {x:0.6, y:0.6}, 0.5, {ease: FlxEase.quartIn} );
			FlxTween.tween(heyLogo, { x: heyLogo.x, y:  195 }, 0.5, {ease: FlxEase.quartIn, onComplete: logoShit2});

			FlxTween.tween(halftoneBlue, { x: 400, y: 900 }, {ease: FlxEase.quartIn});
			FlxTween.tween(cityBack, { x: 400, y: 700 }, {ease: FlxEase.quartIn});
			FlxTween.tween(cityMid, { x: 400, y: 700 }, {ease: FlxEase.quartIn});
			FlxTween.tween(water, { x: water.x, y: 880 }, {ease: FlxEase.quartIn});
			FlxTween.tween(cityFrontAndReflection, { x: 400, y: 678 }, {ease: FlxEase.quartIn});

		}

	}

	function arcadeStickAnims() {
		if (controls.UI_LEFT) {
			arcadeStick.animation.play('left');
		} else if (controls.UI_RIGHT) {
			arcadeStick.animation.play('right');
		} else if (controls.UI_DOWN) {
			arcadeStick.animation.play('down');
		} else if (controls.UI_UP) {
			arcadeStick.animation.play('up');
		} else {
			arcadeStick.animation.play('idle');
		}

	}

	function arcadeStickOffsets() {
		if (arcadeStick.animation.name == 'left') {
			arcadeStick.offset.set(2.25, 0);
		} else {
			arcadeStick.offset.set(0,0);
		}
	}



	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{

		// dont mind me squeezing in here heh this is the actual moving part		
		super.update(elapsed);
		halftoneBlue.scrollX -= -50 * elapsed;
		cityBack.scrollX -= 10 * elapsed;
		cityMid.scrollX -= 40 * elapsed;
		cityFrontAndReflection.scrollX -= 100 * elapsed;



		titleChecks();
		arcadeStickAnims();
		arcadeStickOffsets();

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin && !inTitle)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case CENTER:
					if(controls.UI_LEFT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					else if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case LEFT:
					if(controls.UI_RIGHT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}
			}

			if (controls.BACK && inTitle)
			{
				//selectedSomethin = true;
				//FlxG.mouse.visible = false;
				//FlxG.sound.play(Paths.sound('cancelMenu'));
				//MusicBeatState.switchState(new TitleState());
			}

			if ((controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse)) && !inTitle)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				arcadeButtons.animation.play('select');
				haxe.Timer.delay(() -> arcadeButtons.animation.play('idle'), 100);
				

				//if (ClientPrefs.data.flashing)
					//FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				var item:FlxSprite;
				var option:String;
				switch(curColumn)
				{
					case CENTER:
						option = optionShit[curSelected];
						item = menuItems.members[curSelected];

					case LEFT:
						option = leftOption;
						item = leftItem;

					case RIGHT:
						option = rightOption;
						item = rightItem;
				}

				FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (option)
					{
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());

						#if MODS_ALLOWED
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());
						#end

						#if ACHIEVEMENTS_ALLOWED
						case 'achievements':
							MusicBeatState.switchState(new AchievementsMenuState());
						#end

						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'custom':
							MusicBeatState.switchState(new CustomMenuState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
						case 'donate':
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
							selectedSomethin = false;
							item.visible = true;
						default:
							trace('Menu Item ${option} doesn\'t do anything');
							selectedSomethin = false;
							item.visible = true;
					}
				});
				
				for (memb in menuItems)
				{
					if(memb == item)
						continue;

					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0, playNoise:Bool = true)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		if (playNoise) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		curY = selectedItem.y;
		barMovement(selectedItem);
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}
}
