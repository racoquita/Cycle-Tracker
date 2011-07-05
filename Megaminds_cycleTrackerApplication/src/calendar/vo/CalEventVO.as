package calendar.vo
{
	import flash.display.MovieClip;

	[RemoteClass(alias="calendar.vo.CalEventVO")]
	public class CalEventVO
	{
		public var date:Date = new Date()
		public var content:String = "";
		public var type:String;
		public static const START_PERIOD:String = "period started";
		public static const ADD_ICON:String = "icon added"
		public static const END_PERIOD:String = "period ended"
		public static const ADD_NOTE:String = "note added";
		public static const HAD_SEX:String = "had sex";
		
		public function CalEventVO()
		{
		}
	}
}