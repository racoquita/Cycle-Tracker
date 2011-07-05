package calendar
{
	import calendar.vo.CalEventVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import growl.Growl;
	
	import libs.DataPanel;
	/**
	 * The DataPanel class updates the information based on what the user enters 
	 * @author racoquita
	 * 
	 */	
	public class DataPanel extends libs.DataPanel
	{
		private var _daysOfMonths:Array;
		private var _dueDateString:String;
		private var _cycleDuration:Number = 28;
		private var _xDate:Date 
		private var _dueDate:Date;
		private var _ovulDate:Date;
		private var _currentDate:Date;
		private var _vo:CalEventVO
		
		public function DataPanel()
		{
			super();
			_currentDate = new Date();
			_daysOfMonths = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		}

		/**
		 * This function is called from the Main. It shows the predicted date of next period when the CalEventVO.START_PERIOD is created
		 * Also updates the ovulation date and the day selected for the start period
		 * @param selDate:Date
		 * 
		 */		
		public function update(selDate:Date):void
		{
			if (this.tf_cycleDur.text != "") _cycleDuration = Number(this.tf_cycleDur.text);
			else if(this.tf_cycleDur.text =="") _cycleDuration = 28;
			//shows you when your period starts
			_xDate = new Date(selDate.valueOf());
			this.tf_welcome.text = _xDate.toDateString();
			//updates next month period
			_dueDate = new Date(selDate.fullYear, selDate.month, selDate.date + _cycleDuration);
			this.tf_nextP.text = _dueDate.toDateString();
			if(_currentDate.valueOf() == _dueDate.valueOf()) Growl.sendGrowl("Next Period",'Your period is about to start');
			//Growl notifications 
			//Growl.sendGrowl("Huzzah!",'Growl is working!');

			_ovulDate = new Date(selDate.fullYear, selDate.month, (selDate.date + _cycleDuration/2));
			this.tf_ovulDate.text = _ovulDate.toDateString();
			if(_currentDate.valueOf() == _ovulDate.valueOf()) Growl.sendGrowl("You're ovulating", "Today you are most likely to be fertile")
			
		}
		public function get vo():CalEventVO
		{
			return _vo;
		}
		public function set vo(value:CalEventVO):void
		{
			_vo = value;
		}

	}
}