package com.efg.framework
{

	/**
	 * ...
	 * @author Jeff and Steve Fulton
	 *
	 */
	public class FrameWorkStates
	{
		//等待任何BasicScreen类实例上OK按钮被点击前的状态。
		public static const STATE_SYSTEM_WAIT_FOR_CLOSE:int = 0;
		
		//用来显示一个基本的标题画面，还有一个OK按钮以便用户点击。一旦用户点击按钮，标题画面就会结束，状态就会进行切换。
		public static const STATE_SYSTEM_TITLE:int = 1;
		
		//显示跟SYSTEM_TITLE状态下OK按钮一样的东西。它也会在用户点击OK按钮后切换到STATE_SYSTEM_WAIT_FOR_CLOSE状态。
		public static const STATE_SYSTEM_INSTRUCTIONS:int = 2;
		
		//调用游戏的逻辑类并运行其game.newGame()函数。而且在之后立刻切换到 NEW_LEVEL 状态。
		public static const STATE_SYSTEM_NEW_GAME:int = 3;
		
		//游戏结束的状态会显示一个游戏结束的画面然后等待用户点击OK按钮来回到初始画面。它会很快切换到STATE_SYSTEM_WAIT_FOR_CLOSE直到OK按钮被点击了。
		public static const STATE_SYSTEM_GAME_OVER:int = 4;
		
		//在这个状态下，我们可以调用game.newLevel()函数来给游戏设置一个新的等级。
		public static const STATE_SYSTEM_NEW_LEVEL:int = 5;
		
		//这个状态会在必要的情况下显示一些基本的等级信息。
		public static const STATE_SYSTEM_LEVEL_IN:int = 6;
		
		//这个状态简单的调用游戏逻辑里的runGame函数好让游戏开始其自己的逻辑与状态。
		public static const STATE_SYSTEM_GAME_PLAY:int = 7;
		
		
		public static const STATE_SYSTEM_LEVEL_OUT:int = 8;
		
		//通过一个叫WAIT_COMPLETE的自定义的事件实例和一个数值来实现等待过程。
		public static const STATE_SYSTEM_WAIT:int = 9;
	}

}