package calendar
{
	import calendar.vo.CalEventVO;
	
	import flash.events.Event;
	
	public class PrintEvent extends Event
	{
		public static const PRINTING:String = "print button pressed";
		public function PrintEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new PrintEvent(type, bubbles, cancelable)
		}

	}
}