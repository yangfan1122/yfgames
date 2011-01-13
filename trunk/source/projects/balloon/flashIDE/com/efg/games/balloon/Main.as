package com.efg.games.balloon 
{
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;
	import com.efg.framework.Game;
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
		//Score Level Misses
		static public var SCORE_BOARD_SCORE:String = "score_board_score";
		static public var SCORE_BOARD_LEVEL:String = "score_board_level";
		static public var SCORE_BOARD_MISSES:String = "score_board_misses";
		
		
		public function Main()
		{
			init();
		}
		
		override public function init():void
		{
			game = new BalloonGame();
			setApplicationBackGround(550, 400, false, 0xffffff);
			
			//计分板
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			scoreBoardTextFormat = new TextFormat("_sans", "11", "0x000000", "true");
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement(25, 5, 15, "Score", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			scoreBoard.createTextElement(SCORE_BOARD_LEVEL, new SideBySideScoreElement(85, 5, 10, "Level", scoreBoardTextFormat, 40, "0", scoreBoardTextFormat));
			scoreBoard.createTextElement(SCORE_BOARD_MISSES, new SideBySideScoreElement(170, 5, 10, "Misses", scoreBoardTextFormat, 50, "0", scoreBoardTextFormat));
			
			//初始化 文字信息
			screenTextFormat = new TextFormat("_sans", "16", "0xffffff", "false");//第四个参数：粗体。
			screenTextFormat.align = TextFormatAlign.CENTER;
			screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 550, 400, false, 0x0000dd);
			titleScreen.createOkButton("OK", new Point((stage.stageWidth-40)/2, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);//Point对象，确定位置用。
			titleScreen.createDisplayText("Prick Balloon", 150, new Point((stage.stageWidth-150)/2, 150), screenTextFormat);
			
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 550, 400, false, 0x0000dd);
			instructionsScreen.createOkButton("Play", new Point((stage.stageWidth-80)/2, 250), 80, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			instructionsScreen.createDisplayText("Prick every balloon", 150, new Point((stage.stageWidth-150)/2, 150), screenTextFormat);
			
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 550, 400, false, 0x0000dd);
			gameOverScreen.createOkButton("OK", new Point((stage.stageWidth-40)/2, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			gameOverScreen.createDisplayText("Game Over", 100, new Point((stage.stageWidth-100)/2, 150), screenTextFormat);
			
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 550, 400, true, 0xaaff0000);
			levelInText = "Level ";
			levelInScreen.createDisplayText(levelInText, 100, new Point((stage.stageWidth-100)/2, 150), screenTextFormat);
			
			waitTime = 30;//如果帧频=30，那恰好是1秒。它用的是STATE_SYSTEM_WAIT中的内容作为默认等待时间。
			
			//初始游戏状态
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			frameRate = 30;
			startTimer();
			
			
			
			
			
			
			
			
		}
		
		
	}
	
}