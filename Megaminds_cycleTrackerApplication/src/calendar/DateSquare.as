package calendar
{
	import libs.Box;
	
	public class DateSquare extends Box
	{
		private var _date:Date
		private var _month:Number;
		
		public function DateSquare()
		{
			super();
		}

		public function get date():Date
		{
			return _date;
			//trace(_date.getMonth())
		}

		public function set date(value:Date):void
		{
			
			_date = value;
			
			this.tf_date.text = _date.date + "";
		}

		public function get month():Number
		{
			_month = _date.getMonth()
			return _month;
		}

		public function set month(value:Number):void
		{
			
			_month = value;
		}
	}
}