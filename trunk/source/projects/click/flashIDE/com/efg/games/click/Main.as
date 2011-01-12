package com.efg.games.click
{
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.SideBySideScoreElement;
	
	/**
	 * ...
	 * @author yangfan1122@gmail.com
	 */
	public class Main extends GameFrameWork
	{
		public static const SCORE_BOARD_CLICKS:String = "clicked";
		
		public function Main()
		{
			init();
		}
		
		override public function init():void
		{
			game = new ClickGame();
			setApplicationBackGround(stage.stageWidth, stage.stageHeight, false, 0x666666);
			
			//计分板
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			scoreBoardTextFormat = new TextFormat("_sans", "11", "0xffffff", "true");
			scoreBoard.createTextElement(SCORE_BOARD_CLICKS, new SideBySideScoreElement(25, 5, 15, "Clicks", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
			//初始化 文字信息
			screenTextFormat = new TextFormat("_sans", "16", "0xffffff", "false");//第四个参数：粗体。
			screenTextFormat.align = TextFormatAlign.CENTER;
			screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 400, 400, false, 0x0000dd);
			titleScreen.createOkButton("OK", new Point(170, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);//Point对象，确定位置用。
			titleScreen.createDisplayText("Click Game", 100, new Point(145, 150), screenTextFormat);
			
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 400, 400, false, 0x0000dd);
			instructionsScreen.createOkButton("Play", new Point(150, 250), 80, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			instructionsScreen.createDisplayText("Click the mouse\n10 times", 150, new Point(120, 150), screenTextFormat);
			
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 400, 400, false, 0x0000dd);
			gameOverScreen.createOkButton("OK", new Point(170, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			gameOverScreen.createDisplayText("Game Over", 100, new Point(140, 150), screenTextFormat);
			
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 400, 400, true, 0xaaff0000);
			levelInText = "Level ";
			levelInScreen.createDisplayText(levelInText, 100, new Point(150, 150), screenTextFormat);
			
			waitTime = 30;//如果帧频=30，那恰好是1秒。它用的是STATE_SYSTEM_WAIT中的内容作为默认等待时间。
			
			//初始游戏状态
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			frameRate = 30;
			startTimer();
			
		}
		
		
		
	}
	
}