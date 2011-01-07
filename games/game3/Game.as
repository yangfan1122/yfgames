package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.*;
	import flash.ui.Mouse;

	public class Game extends flash.display.MovieClip
	{
		public static const STATE_INIT:int = 10;
		public static const STATE_START_PLAYER:int = 20;
		public static const STATE_PLAY_GAME:int = 30;
		public static const STATE_REMOVE_PLAYER:int = 40;
		public static const STATE_END_GAME:int = 50;
		public var gameState:int = 0;
		public var score:int = 0;
		public var chances:int = 0;
		public var bg:MovieClip;
		public var enemies:Array;
		public var missiles:Array;//导弹
		public var explosions:Array;
		public var player:MovieClip;
		public var level:Number = 0;
		public var scoreLabel:TextField = new TextField();
		public var levelLabel:TextField = new TextField();
		public var chancesLabel:TextField = new TextField();
		public var scoreText:TextField = new TextField();
		public var levelText:TextField = new TextField();
		public var chancesText:TextField = new TextField();
		public const SCOREBOARD_Y:Number = 5;

		public function Game()
		{
			addEventListener(Event.ENTER_FRAME, gameLoop);
			bg = new BackImage();
			addChild(bg);
			scoreLabel.text = "Score:";
			levelLabel.text = "Level:";
			chancesLabel.text = "Ships:";
			scoreText.text = "0";
			levelText.text = "1";
			chancesText.text = "0";
			scoreLabel.selectable = false;
			levelLabel.selectable = false;
			chancesLabel.selectable = false;
			scoreText.selectable = false;
			levelText.selectable = false;
			chancesText.selectable = false;
			scoreLabel.y = SCOREBOARD_Y;
			levelLabel.y = SCOREBOARD_Y;
			chancesLabel.y = SCOREBOARD_Y;
			scoreText.y = SCOREBOARD_Y;
			levelText.y = SCOREBOARD_Y;
			chancesText.y = SCOREBOARD_Y;
			scoreLabel.x = 5;
			scoreText.x = 50;
			chancesLabel.x = 105;
			chancesText.x = 155;
			levelLabel.x = 205;
			levelText.x = 260;
			scoreLabel.textColor = 0xFF0000;
			scoreText.textColor = 0xFFFFFF;
			levelLabel.textColor = 0xFF0000;
			levelText.textColor = 0xFFFFFF;
			chancesLabel.textColor = 0xFF0000;
			chancesText.textColor = 0xFFFFFF;
			addChild(scoreLabel);
			addChild(levelLabel);
			addChild(chancesLabel);
			addChild(scoreText);
			addChild(levelText);
			addChild(chancesText);
			gameState = STATE_INIT;
			
			Mouse.hide();
		}

		public function gameLoop(e:Event)
		{
			switch (gameState)
			{
				case STATE_INIT:
					initGame();
					break
				case STATE_START_PLAYER:
					startPlayer();
					break;
				case STATE_PLAY_GAME:
					playGame();
					break;
				case STATE_REMOVE_PLAYER:
					removePlayer();
					break;
				case STATE_END_GAME:
					break;
			}
		}

		public function initGame()
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEvent);
			score = 0;
			chances = 3;
			enemies = new Array();
			missiles = new Array();
			explosions = new Array();
			level = 1;
			levelText.text = level.toString();
			player = new PlayerImage();
			gameState = STATE_START_PLAYER;
		}

		public function startPlayer()
		{
			addChild(player);
			player.startDrag(true, new Rectangle(0, 365, 550, 0));
			gameState = STATE_PLAY_GAME;
		}

		public function removePlayer()
		{
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				removeEnemy(i);
			}
			for (i = missiles.length - 1; i >= 0; i--)
			{
				removeMissile(i);
			}
			removeChild(player);
			gameState = STATE_START_PLAYER;
		}

		public function playGame()
		{
			makeEnemies();
			moveEnemies();
			testCollisions();
			testForEnd();
		}

		public function makeEnemies()
		{
			var chance:int = Math.floor(Math.random() * 100);
			var tempEnemy:MovieClip;
			if (chance < 2 + level)
			{
				tempEnemy = new EnemyImage()
				tempEnemy.speed = 1 + level;
				tempEnemy.y = -25;
				tempEnemy.x = Math.floor(Math.random() * 515)
				addChild(tempEnemy);
				enemies.push(tempEnemy);
			}
		}

		public function moveEnemies()  //对象跟踪，移除显示对象
		{
			var tempEnemy:MovieClip;//敌人
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				tempEnemy.y += tempEnemy.speed;
				if (tempEnemy.y > 435)
				{
					removeEnemy(i);
				}
			}
			var tempMissile:MovieClip;//导弹
			for (i = missiles.length - 1; i >= 0; i--)
			{
				tempMissile = missiles[i];
				tempMissile.y -= tempMissile.speed;
				if (tempMissile.y < -35)
				{
					removeMissile(i);
				}
			}
			var tempExplosion:MovieClip;//爆炸效果
			for (i = explosions.length - 1; i >= 0; i--)
			{
				tempExplosion = explosions[i];
				if (tempExplosion.currentFrame >= tempExplosion.totalFrames)
				{
					removeExplosion(i);
				}
			}
		}

		public function testCollisions()
		{
			var tempEnemy:MovieClip;
			var tempMissile:MovieClip;
			enemy: for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				for (var j:int = missiles.length - 1; j >= 0; j--)
				{
					tempMissile = missiles[j];
					if (tempEnemy.hitTestObject(tempMissile))
					{
						score++;
						scoreText.text = score.toString();
						makeExplosion(tempEnemy.x, tempEnemy.y);
						removeEnemy(i);
						removeMissile(j);
						break enemy;
					}
				}
			}
			for (i = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				if (tempEnemy.hitTestObject(player))
				{
					chances--;
					chancesText.text = chances.toString();
					makeExplosion(tempEnemy.x, tempEnemy.y);
					gameState = STATE_REMOVE_PLAYER;
				}
			}
		}

		public function makeExplosion(ex:Number, ey:Number)
		{
			var tempExplosion:MovieClip;
			tempExplosion = new ExplosionImage();
			tempExplosion.x = ex;
			tempExplosion.y = ey;
			addChild(tempExplosion);
			explosions.push(tempExplosion);
			var sound:Sound = new Explode();
			sound.play();
		}

		public function testForEnd()
		{
			if (chances <= 0)
			{
				removePlayer();
				gameState = STATE_END_GAME;
			}
			else if (score > level * 30)
			{
				level++;
				levelText.text = level.toString();
			}
		}

		public function removeEnemy(idx:int)
		{
			removeChild(enemies[idx]);
			enemies.splice(idx, 1);
		}

		public function removeMissile(idx:int)
		{
			removeChild(missiles[idx]);
			missiles.splice(idx, 1);
		}

		public function removeExplosion(idx:int)
		{
			removeChild(explosions[idx]);
			explosions.splice(idx, 1);
		}

		public function onMouseDownEvent(e:MouseEvent)
		{
			if (gameState == STATE_PLAY_GAME)
			{
				var tempMissile:MovieClip = new MissileImage();
				tempMissile.x = player.x + (player.width / 2);
				tempMissile.y = player.y;
				tempMissile.speed = 5;
				missiles.push(tempMissile);
				addChild(tempMissile);
				var sound:Sound = new Shoot();
				sound.play();
			}
		}
	}
}