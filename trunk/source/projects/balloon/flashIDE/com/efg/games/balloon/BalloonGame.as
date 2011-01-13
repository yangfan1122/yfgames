package com.efg.games.balloon
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	
	/**
	 * ...
	 * @author yangfan1122@gmail.com
	 */
	public class BalloonGame extends Game
	{
		private var level:int;
		private var chances:int = 0;//错过气球数，misses
		private var score:int = 0;
		
		public var enemies:Array;
		public var player:MovieClip;
		
		public function BalloonGame()
		{
		}

		override public function newGame():void
		{
			chances = 0;
			level = 0;
			score = 0;
			enemies = new Array();
			
			player = new PlayerImage();
			addChild(player);
			player.startDrag(true, new Rectangle(0, 0, 550, 400));
			
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, String(score)));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_LEVEL, String(level)));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_MISSES, String(chances)));
			
		}

		override public function newLevel():void
		{
			level++;
			
			dispatchEvent(new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));//关卡提示
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_LEVEL, String(level)));
		}

		override public function runGame():void
		{
			player.rotation += 15;
			
			makeEnemies();
			moveEnemies();
			testCollisions();
			testForEnd();
			
		}
		
		
		
		

		
		private function makeEnemies():void
		{
			var chance:Number = Math.floor(Math.random() * 100);
			var tempEnemy:MovieClip;
			if (chance < 2 + level)
			{
				tempEnemy = new EnemyImage()
				tempEnemy.speed = 3 + level;
				tempEnemy.gotoAndStop(Math.floor(Math.random() * 5) + 1);
				tempEnemy.y = 435;
				tempEnemy.x = Math.floor(Math.random() * 515);//气球x坐标
				addChild(tempEnemy);
				enemies.push(tempEnemy);
			}
		}

		private function moveEnemies():void
		{
			var tempEnemy:MovieClip;
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				tempEnemy.y -= tempEnemy.speed;
				if (tempEnemy.y < -35)//飞到顶端外，气球逃脱
				{
					chances++;
					//chancesText.text = chances.toString();
					dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_MISSES, String(chances)));
					enemies.splice(i, 1);
					removeChild(tempEnemy);
				}
			}
		}
		
		private function testCollisions():void
		{
			var sound:Sound = new Pop();
			var tempEnemy:MovieClip;
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				if (tempEnemy.hitTestObject(player))
				{
					score++;
					//scoreText.text = score.toString();
					dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SCORE, String(score)));
					sound.play();
					enemies.splice(i, 1);
					removeChild(tempEnemy);
				}
			}
		}
		
		private function testForEnd():void
		{
			if (chances >= 5)
			{
				//trace("game over");
				dispatchEvent(new Event(GAME_OVER));//GameFrameWork中监听
				cleanUp();
			}
			else if (score >= level * 20)
			{
				dispatchEvent(new Event(NEW_LEVEL));//关卡提示
			}
		}
		
		
		private function cleanUp():void
		{
			for (var i:int = enemies.length-1; i >= 0; i-- ) removeChild(enemies[i]);
			removeChild(player);
		}
		
		
		
		
		
		
	}
	
}