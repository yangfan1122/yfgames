package com.efg.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class GameFrameWork extends MovieClip
	{
		public static const EVENT_WAIT_COMPLETE:String = "wait complete";
		public var systemFunction:Function;//在每帧执行的时候调用相应的状态行为函数
		public var currentSystemState:int;//通过用一个整形变量来保存当前状态
		public var nextSystemState:int;//下一个状态
		public var lastSystemState:int;//之前的状态
		public var appBackBitmapData:BitmapData;
		public var appBackBitmap:Bitmap;
		public var frameRate:int;
		public var timerPeriod:Number;//通过Timer实例来实现而且游戏也会企图用这个速率来运行
		public var gameTimer:Timer;
		public var titleScreen:BasicScreen;
		public var gameOverScreen:BasicScreen;
		public var instructionsScreen:BasicScreen;
		public var levelInScreen:BasicScreen;
		public var screenTextFormat:TextFormat;
		public var screenButtonFormat:TextFormat;
		public var levelInText:String;
		public var scoreBoard:ScoreBoard;
		public var scoreBoardTextFormat:TextFormat;
//Game is our custom class to hold all logic for the game.
		public var game:Game;
//waitTime is used in conjunction with the
//STATE_SYSTEM_WAIT state
// it suspends the game and allows animation or other
//processing to finish
		public var waitTime:int;
		public var waitCount:int = 0;

		public function GameFrameWork()
		{
		}

		public function init():void
		{
//stub to override
		}

		public function setApplicationBackGround(width:Number, height:Number, isTransparent:Boolean = false, color:uint = 0x000000):void
		{
			appBackBitmapData = new BitmapData(width, height, isTransparent, color);
			appBackBitmap = new Bitmap(appBackBitmapData);
			addChild(appBackBitmap);
		}

		public function startTimer():void
		{
			timerPeriod = 1000 / frameRate;
			gameTimer = new Timer(timerPeriod);
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();
		}

		public function runGame(e:TimerEvent):void
		{
			systemFunction();
			e.updateAfterEvent();//可以让Flash 的显示机制在每个时间周期内平滑的进行屏幕着色，而不是根据.swf文件设置的帧频来刷新屏幕。
		}

//switchSystem state is called only when the
//state is to be changed
//(not every frame like in some switch/case
//based simple state machines
		public function switchSystemState(stateval:int):void
		{
			//可以在返回上个状态时有个参考。这种情况可能是我们在STATE_SYSTEM_WAIT状态的一个时间周期内想跳回我们在等待之前的状态。
			lastSystemState = currentSystemState;
			
			
			currentSystemState = stateval;
			switch (stateval)
			{
				case FrameWorkStates.STATE_SYSTEM_WAIT:
					systemFunction = systemWait;
					break;
				case FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE:
					systemFunction = systemWaitForClose;
					break;
				case FrameWorkStates.STATE_SYSTEM_TITLE:
					systemFunction = systemTitle;
					break;
				case FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS:
					systemFunction = systemInstructions;
					break;
				case FrameWorkStates.STATE_SYSTEM_NEW_GAME:
					systemFunction = systemNewGame;
					break;
				case FrameWorkStates.STATE_SYSTEM_NEW_LEVEL:
					systemFunction = systemNewLevel;
					break;
				case FrameWorkStates.STATE_SYSTEM_LEVEL_IN:
					systemFunction = systemLevelIn;
					break;
				case FrameWorkStates.STATE_SYSTEM_GAME_PLAY:
					systemFunction = systemGamePlay;
					break
				case FrameWorkStates.STATE_SYSTEM_GAME_OVER:
					systemFunction = systemGameOver;
					break;
			}
		}

		public function systemTitle():void
		{
			addChild(titleScreen);
			titleScreen.addEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener, false, 0, true);
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS;
		}

		public function systemInstructions():void //给用户显示介绍画面
		{
			addChild(instructionsScreen);
			instructionsScreen.addEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener, false, 0, true);
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_NEW_GAME;
		}

		public function systemNewGame():void
		{
			addChild(game);
			game.addEventListener(CustomEventScoreBoardUpdate.UPDATE_TEXT, scoreBoardUpdateListener, false, 0, true);
			game.addEventListener(CustomEventLevelScreenUpdate.UPDATE_TEXT, levelScreenUpdateListener, false, 0, true);
			game.addEventListener(Game.GAME_OVER, gameOverListener, false, 0, true);
			game.addEventListener(Game.NEW_LEVEL, newLevelListener, false, 0, true);
			game.newGame();
			switchSystemState(FrameWorkStates.STATE_SYSTEM_NEW_LEVEL);
		}

		public function systemNewLevel():void
		{
			game.newLevel();
			switchSystemState(FrameWorkStates.STATE_SYSTEM_LEVEL_IN);
		}

		public function systemLevelIn():void
		{
			addChild(levelInScreen);
			waitTime = 30;
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_GAME_PLAY;
			addEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener, false, 0, true);
		}

		public function systemGameOver():void
		{
			removeChild(game);
			addChild(gameOverScreen);
			gameOverScreen.addEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener, false, 0, true);
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_TITLE;
		}

		public function systemGamePlay():void
		{
			game.runGame();
		}

		public function systemWaitForClose():void
		{
//do nothing
		}

		public function systemWait():void
		{
			waitCount++;
			if (waitCount > waitTime)
			{
				waitCount = 0;
				dispatchEvent(new Event(EVENT_WAIT_COMPLETE));
			}
		}

		public function okButtonClickListener(e:CustomEventButtonId):void
		{
			switch (e.id)
			{
				case FrameWorkStates.STATE_SYSTEM_TITLE:
					removeChild(titleScreen);
					titleScreen.removeEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener);
					break;
				case FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS:
					removeChild(instructionsScreen);
					instructionsScreen.removeEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener);
					break;
				case FrameWorkStates.STATE_SYSTEM_GAME_OVER:
					removeChild(gameOverScreen);
					gameOverScreen.removeEventListener(CustomEventButtonId.BUTTON_ID, okButtonClickListener);
					break;
			}
			switchSystemState(nextSystemState);
		}

		public function scoreBoardUpdateListener(e:CustomEventScoreBoardUpdate):void
		{
			scoreBoard.update(e.element, e.value);
		}

		public function levelScreenUpdateListener(e:CustomEventLevelScreenUpdate):void
		{
			levelInScreen.setDisplayText(levelInText + e.text);
		}

//gameOverListener listens for Game.GAMEOVER simple
//custom events calls and changes state accordingly
		public function gameOverListener(e:Event):void
		{
			switchSystemState(FrameWorkStates.STATE_SYSTEM_GAME_OVER);
			game.removeEventListener(CustomEventScoreBoardUpdate.UPDATE_TEXT, scoreBoardUpdateListener);
			game.removeEventListener(CustomEventLevelScreenUpdate.UPDATE_TEXT, levelScreenUpdateListener);
			game.removeEventListener(Game.GAME_OVER, gameOverListener);
			game.removeEventListener(Game.NEW_LEVEL, newLevelListener);
		}

//newLevelListener listens for Game.NEWLEVEL
//simple custom events calls and changes state accordingly
		public function newLevelListener(e:Event):void
		{
			switchSystemState(FrameWorkStates.STATE_SYSTEM_NEW_LEVEL);
		}

		public function waitCompleteListener(e:Event):void
		{
			switch (lastSystemState)
			{
				case FrameWorkStates.STATE_SYSTEM_LEVEL_IN:
					removeChild(levelInScreen);
					break
			}
			removeEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener);
			switchSystemState(nextSystemState);
		}
	}
}