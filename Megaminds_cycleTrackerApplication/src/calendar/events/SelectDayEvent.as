package calendar.events
{
	import calendar.vo.CalEventVO;
	
	import flash.events.Event;
	
	public class SelectDayEvent extends Event
	{
		public var monthSelected:Number;
		public var dateofSelMonth:Date
		public var vo:CalEventVO;
		public static const MONTH_CHANGED:String = "month changed"
		public static const NEXT_MONTH:String = 'nextMonth';
		public static const PREV_MONTH:String = "prevMonth";
		public static const REM_VO:String = "remove Event";
		public function SelectDayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new SelectDayEvent(type, bubbles, cancelable)
		}
	}
}