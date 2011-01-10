package com.efg.framework
{
// Import necessary classes from the flash libraries
	import flash.display.MovieClip;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.CustomEventLevelScreenUpdate;

	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class Game extends MovieClip
	{
//Create constants for simple custom events
		public static const GAME_OVER:String = "game over";
		public static const NEW_LEVEL:String = "new level";

//Constructor calls init() only
		public function Game()
		{
		}

		public function newGame():void
		{
		}

		public function newLevel():void
		{
		}

		public function runGame():void
		{
		}
	}
}