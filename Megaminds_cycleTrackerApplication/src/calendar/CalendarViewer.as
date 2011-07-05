package calendar
{
	import calendar.events.SelectDayEvent;
	import calendar.vo.CalEventVO;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	
	import libs.CalendarViewer;
	
	public class CalendarViewer extends libs.CalendarViewer
	{
		private var _options:PrintJobOptions;
		public var print_job:PrintJob;
		private var _amount:int;
		private var my_sprite:Sprite;
		
		public function CalendarViewer()
		{
			super();
			initChromeControls();
		}
		/**
		 * This function initialize the calendar viewer controls 
		 * 
		 */		
		private function initChromeControls():void
		{
			this.mc_close.addEventListener(MouseEvent.CLICK, onCloseClick);
			this.mc_close.buttonMode = true;
			this.mc_minimize.addEventListener(MouseEvent.CLICK, onMinClick);
			this.mc_minimize.buttonMode = true;
			this.mc_print.addEventListener(MouseEvent.MOUSE_DOWN, onPrintClick);
			this.mc_print.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDragScreen);
		}
		/**
		 * onPrintClick handles what happens when the print button is clicked
		 * @param e:MouseEvent
		 * 
		 */		
		private function onPrintClick(e:MouseEvent):void
		{
			var printEvent:PrintEvent = new  PrintEvent(PrintEvent.PRINTING);
			this.dispatchEvent(printEvent);
		}
		/**
		 * onCloseClick function closes the application when the close button is clicked
		 * @param e:MouseEvent
		 * 
		 */		
		private function onCloseClick(e:MouseEvent):void
		{
			stage.nativeWindow.close();
		}
		private function onMinClick(e:MouseEvent):void
		{
			stage.nativeWindow.minimize();
		}
		private function onDragScreen(e:MouseEvent):void
		{
			stage.nativeWindow.startMove();
	}
			
	}
}