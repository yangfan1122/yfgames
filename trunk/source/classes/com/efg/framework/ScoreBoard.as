package com.efg.framework
{
// Import necessary classes from the flash libraries
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;

	/**
	 * ...
	 * @author Jeff Fulton and Steve Fulton
	 */
	public class ScoreBoard extends Sprite
	{
		private var textElements:Object;

//Constructor calls init() only
		public function ScoreBoard()
		{
			init();
		}

		private function init():void
		{
			textElements = {};
		}

		public function createTextElement(key:String, obj:SideBySideScoreElement):void
		{
			textElements[key] = obj;
			addChild(obj);//文档类中ScoreBoard的实例已加载到舞台上
		}

		public function update(key:String, value:String):void
		{
			var tempElement:SideBySideScoreElement = textElements[key];
			tempElement.setContentText(value);
		}
	}
}