package calendar
{
	import calendar.events.SelectDayEvent;
	import calendar.vo.CalEventVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import libs.OptionPanel;
	
	public class DeleteOptionPanel extends OptionPanel
	{
		private var _vo:CalEventVO;
		private var _voA:Array;
		
		public function DeleteOptionPanel()
		{
			super();
			initControls();
		}
		private function initControls():void
		{
			this.btn_yes.mouseChildren =false;
			this.btn_yes.buttonMode = true;
			this.btn_yes.addEventListener(MouseEvent.CLICK, onYesClick);
			this.btn_no.addEventListener(MouseEvent.CLICK, onYesClick);
			this.btn_no.buttonMode = true;
			this.btn_no.mouseChildren = false;
			
		}
		/**
		 * This function closes the DeleteOptionPanel
		 * @param e:MouseEvent
		 * 
		 */		
		public function onYesClick(e:MouseEvent):void
		{
			this.parent.removeChild(this);
		}
		public function get vo():CalEventVO
		{
			return _vo;
		}
		public function set vo(value:CalEventVO):void
		{
			_vo = value;
		}

		public function get voA():Array
		{
			return _voA;
		}

		public function set voA(value:Array):void
		{
			_voA = value;
		}


	}
}