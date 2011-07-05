package calendar
{
	import calendar.vo.CalEventVO;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PopupEvent extends Event
	{
		public var btnname:String;
		public var selDate:Date;
		public var eventData:CalEventVO;
		public static const ADD_ICON:String = "icon added"
		public static const CHANGE_NAME:String = "change Name";
		public static const ADD_NOTE:String = "note Added";
		public static const SELECT_BOX:String = "select box";
		public static const ADD_EVENT:String = "event added";
		public static const REMOVE_EVENT:String = "event added";
		public static const STARTPERIOD_EVENT:String = "period started";
		public static const ENDPERIOD_EVENT:String = "period ended";
		public function PopupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new PopupEvent(type, bubbles, cancelable)
		}
	}
}