package com.efg.games.balloon
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	
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
		private var chances:int = 0;
		
		public var enemies:Array;
		public var player:MovieClip;
		
		public function BalloonGame()
		{
		}

		override public function newGame():void
		{
			trace("newGame ~~");
			chances = 0;
			
			player = new PlayerImage();
			enemies = new Array();
			level = 1;
			
			addChild(player);
			player.startDrag(true, new Rectangle(0, 0, 550, 400));
			
			
			
		}

		override public function newLevel():void
		{
		}

		override public function runGame():void
		{
			trace("run game ~~~~");
			
		}
		
	}
	
}