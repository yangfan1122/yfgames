
package com.efg.games.superclick
{
	// Import necessary classes from the flash libraries
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	/**
	* ...
	* @author Jeff Fulton
	*/
	public class SuperClick extends com.efg.framework.Game
	{
		//game logic and flow
		private var score:int;
		private var level:int;
		private var percent:Number;
		private var clicked:int;
		private var gameOver:Boolean;
		private var circles:Array;
		private var tempCircle:Circle;
		private var numCreated:int;
		//messaging
		private var scoreTexts:Array;
		private var tempScoreText:ScoreTextField;
		private var textFormat:TextFormat = new TextFormat("_sans",12,"0xffffff","true");
		//game level difficulty
		private var maxScore:int = 50;
		private var numCircles:int;
		private var circleGrowSpeed:Number;
		private var circleMaxSize:Number;
		private var percentNeeded:Number;
		private var maxCirclesOnscreen:int;
		private var percentBadCircles:Number;


		public function SuperClick()
		{
		}

		override public function newGame():void
		{
			trace("new game");
			level = 0;
			score = 0;
			gameOver = false;
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE,"0"));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_CLICKED,"0/0"));
			dispatchEvent(new CustomEventScoreBoardUpdate (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PERCENT_NEEDED,"0%"));
			dispatchEvent(new CustomEventScoreBoardUpdate (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PERCENT_ACHIEVED,"0%"));
		}



		override public function newLevel():void
		{
			trace("new level");
			percent = 0;
			clicked = 0;
			circles = [];
			scoreTexts = [];
			level++;
			numCircles = level * 25;
			circleGrowSpeed = .01 * level;
			circleMaxSize = (level < 5) ? 5-level : 1;
			percentNeeded = 10 + (5 * level);
			if (percentNeeded > 90)
			{
				percentNeeded = 90;
			}
			maxCirclesOnscreen = 10 * level;
			numCreated = 0;
			percentBadCircles = (level < 25) ? level + 9 : 40;
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PERCENT_NEEDED, String(percentNeeded)));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_CLICKED,String(clicked + "/" +numCircles)));
			dispatchEvent(new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
		}



		override public function runGame():void
		{
			trace("run game");
			update();
			checkCollisions();
			render();
			checkforEndLevel();
			checkforEndGame();
		}



		private function update():void
		{
			if (circles.length < maxCirclesOnscreen && numCreated < numCircles)
			{
				var newCircle:Circle;
				if (int(Math.random() * 100) <= percentBadCircles)
				{
					newCircle = new Circle(Circle.CIRCLE_BAD);
				}
				else
				{
					newCircle = new Circle(Circle.CIRCLE_GOOD);
					numCreated++;
				}
				addChild(newCircle);
				circles.push(newCircle);
			}
			// Checks circles every frame for size and adds;
			//to their nextScale property
			// if nextScale is larger than the max, removes the circle
			var circleLength:int = circles.length - 1;
			for (var counter:int = circleLength; counter >= 0; counter--)
			{
				tempCircle = circles[counter];
				tempCircle.update(circleGrowSpeed);
				if (tempCircle.nextScale > circleMaxSize || tempCircle.alpha < 0)
				{
					removeCircle(counter);
				}
			}
			var scoreTextLength:int = scoreTexts.length - 1;
			for (counter= scoreTextLength; counter >= 0; counter--)
			{
				tempScoreText = scoreTexts[counter];
				if (tempScoreText.update())
				{//returns true is life is over
					removeScoreText(counter);
				}
			}
		}


		private function removeCircle(counter:int):void
		{
			tempCircle = circles[counter];
			tempCircle.dispose();
			removeChild(tempCircle);
			circles.splice(counter, 1);
		}




		private function removeScoreText(counter:int):void
		{
			tempScoreText = scoreTexts[counter];
			tempScoreText.dispose();
			removeChild(tempScoreText);
			scoreTexts.splice(counter, 1);
		}






		private function checkCollisions():void
		{
			var circleLength:int = circles.length - 1;
			for (var counter:int = circleLength; counter >= 0; counter--)
			{
				tempCircle = circles[counter];
				if (tempCircle.clicked && ! tempCircle.fadingOut)
				{
					tempCircle.fadingOut = true;
					if (tempCircle.type == Circle.CIRCLE_GOOD && tempCircle.alpha == 1)
					{
						var scoreAdjust:Number = 1 / tempCircle.scaleX;
						var scoreAdd:int = maxScore * scoreAdjust;
						addToScore(scoreAdd);
						tempScoreText = new ScoreTextField(String(scoreAdd),textFormat,tempCircle.x,tempCircle.y,20);
						scoreTexts.push(tempScoreText);
						addChild(tempScoreText);
					}
					else if (tempCircle.type==Circle.CIRCLE_BAD)
					{
						gameOver = true;
					}
				}
			}
		}


		private function addToScore(scoreAdd:Number):void
		{
			score +=  scoreAdd;
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SCORE,String(score)));
			clicked++;
			percent = 100 * (clicked / numCircles);
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PERCENT_ACHIEVED, String(percent)));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_CLICKED,String(clicked + "/" +numCircles)));
		}

		private function render():void
		{
			var circleLength:int = circles.length - 1;
			for (var counter:int = circleLength; counter >= 0; counter--)
			{
				tempCircle = circles[counter];
				tempCircle.scaleX = tempCircle.nextScale;
				tempCircle.scaleY = tempCircle.nextScale;
			}
		}




		private function checkforEndGame():void
		{
			if (gameOver)
			{
				dispatchEvent(new Event(GAME_OVER));
				cleanUp();
			}
		}





		private function checkforEndLevel():void
		{
			if (circles.length == 0 && numCreated == numCircles && scoreTexts.length == 0)
			{
				if (percent >= percentNeeded)
				{
					dispatchEvent(new Event(NEW_LEVEL));
				}
				else
				{
					gameOver = true;
				}
			}
		}







		private function cleanUp():void
		{
			var circleLength:int = circles.length - 1;
			for (var counter:int = circleLength; counter >= 0; counter--)
			{
				removeCircle(counter);
			}
			var scoreTextLength:int = scoreTexts.length - 1;
			for (counter= scoreTextLength; counter >= 0; counter--)
			{
				removeScoreText(counter);
			}
		}
	}// close class
}// close package