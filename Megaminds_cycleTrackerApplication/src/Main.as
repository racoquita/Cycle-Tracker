package
{
	import calendar.Calendar;
	import calendar.CalendarViewer;
	import calendar.DataPanel;
	import calendar.DeleteOptionPanel;
	import calendar.PopupEvent;
	import calendar.PrintEvent;
	import calendar.events.SelectDayEvent;
	import calendar.vo.CalEventVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	
	import growl.Growl;
	
	[SWF( width = "905", height ="600", frameRate="60", backgroundColor = "0xEFEBDB")]
	public class Main extends Sprite
	{
		private var _currentMonth:uint= 4;
		private var _calEvents:Array;
		private var _cal:Calendar;
		private var _selDate:Date
		private var _selMonth:Number;
		private var _dataPanel:DataPanel;
		private var _delCalVO:CalEventVO;
		private var _currentDate:Date = new Date
		private var _deleteOptionP:DeleteOptionPanel;
	
		private var _options:PrintJobOptions;
		public var print_job:PrintJob;
		
		private var _amount:int;
		private var my_sprite:Sprite;
		
		public function Main()
		{	
			init();
			registerClassAlias("calendar.vo.CalEventVO",CalEventVO);
		}
		private function init():void
		{
			stage.addEventListener(Event.SELECT, onPrint);
			var chrome:CalendarViewer = new CalendarViewer();
			addChild(chrome);
			chrome.addEventListener(PrintEvent.PRINTING, onPrint);
			
			_dataPanel = new DataPanel();
			_dataPanel.x =  15;
			_dataPanel.y = 100;
			
			addChild(_dataPanel);
			_cal = new Calendar();
			_cal.x = 350;
			_cal.y = 100;
			addChild(_cal);
			
			var f:File = File.applicationStorageDirectory;
			f.nativePath += File.separator + "CycleTracker";
			
			if(f.exists)
			{
				var fs2:FileStream = new FileStream();
				fs2.open(f,FileMode.READ);
				_calEvents = fs2.readObject() as Array;
				fs2.close();
			}else{
				_calEvents = createData();
			}
			_cal.addEventListener(SelectDayEvent.NEXT_MONTH, onNextMonth);
			_cal.addEventListener(SelectDayEvent.PREV_MONTH, onPrevMonth);
			
			_cal.addEventListener(PopupEvent.ADD_EVENT, eventAdded);
			_cal.update(_currentMonth, _calEvents);
			_cal.addEventListener(SelectDayEvent.REM_VO, removedEvent);
		}
		/**
		 * This function runs after an calEventVO has been added to the calendar 
		 * @param e:PopupEvent
		 * 
		 */		
		private function eventAdded(e:PopupEvent):void
		{
			_calEvents.push(e.eventData);
			_cal.update(_currentMonth,_calEvents);
			if(e.eventData.type == CalEventVO.START_PERIOD)
			{
				_dataPanel.update(e.eventData.date);
				Growl.sendGrowl("Your Cycle starts",'Remember to take notes of any symptoms you might have')
			}
			if(e.eventData.type == CalEventVO.END_PERIOD)
			{
				_dataPanel.update(e.eventData.date);
				Growl.sendGrowl("Your Cycle Ends Here",'Your fertility is low');
			}
		}
		/**
		 * This Function prints what's on the calendar
		 * @param e:PrintEvent
		 * 
		 */		
		private function onPrint(e:PrintEvent):void
		{
			_amount = numChildren;
			my_sprite = new Sprite();
			
			this.addChild(my_sprite);
			my_sprite.graphics.drawRect(0 , 0, 906, 600);
			print_job = new PrintJob();
			_options = new PrintJobOptions();
			_options.printAsBitmap = true;			
			if(print_job.start())
			{
				try
				{
					if(my_sprite.width > print_job.pageWidth)
					{	
						my_sprite.width = print_job.pageWidth;
						my_sprite.scaleY =  my_sprite.scaleX;
					}
					addContentToSprite();
				} 
				catch (error:Error) 
				{
					trace(error);
				}
				print_job.send();
				removeContentAndSprite();
			} 
			else
			{
				removeChild(my_sprite);
			}
		}
		private function addContentToSprite():void 
		{
			for (var i:int=0;i < _amount;i++) 
			{
				my_sprite.addChild(this.getChildAt(0));
			}
			print_job.addPage(my_sprite, null, _options);
		}
		private function removeContentAndSprite():void
		{
			for (var i:int=0;i < _amount;i++)
			{
				this.addChild(my_sprite.getChildAt(0));
			}
			removeChild(my_sprite);
		}
		/**
		 * This function runs when the icon is clicked
		 * @param e:PopupEvent
		 * 
		 */		
		private function removedEvent(e:SelectDayEvent):void
		{
			_delCalVO = e.vo;
			for(var i:int = 0; i < _calEvents.length; i++)
			{
				if(_delCalVO.date == _calEvents[i].date)
				{
					_calEvents.splice(i, 1);
				}
			}
			_cal.update(_currentMonth, _calEvents);
		}
		private function onNextMonth(e:SelectDayEvent):void
		{
			_currentMonth+=1;
			_cal.update(_currentMonth,  _calEvents);
			trace(_currentMonth)
		}
		/**
		 * This function updates the calendar when the user clicks on the previous month
		 * @param e:Event 
		 * 
		 */		
		private function onPrevMonth(e:SelectDayEvent):void
		{
			_currentMonth-=1;
			//_selDate = new Date(2011, _currentMonth)
			_cal.update(_currentMonth, _calEvents);
			
			if(_currentMonth == 0 )
			{
				
//				_selDate.fullYear--
//				_currentMonth = 12
			}
		}
		private function createData():Array
		{
			var retArray:Array = [];
			return retArray
		}
	}
}