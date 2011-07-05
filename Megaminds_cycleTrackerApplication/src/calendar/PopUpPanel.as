package calendar
{
	import calendar.ButtonGroup;
	import calendar.vo.CalEventVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import libs.MyCheckBox;
	import libs.PopUpPanel;
	
	public class PopUpPanel extends libs.PopUpPanel
	{
		private var _buttons:Array
		private var _checkBox:CheckBox;
		private var _btnGroup:ButtonGroup;
		private var _selectedBox:String;
		private var _date:Date;
		private var _calvoSaveNote:CalEventVO;
		public static const BOXNAME_CHANGE:String = "change box Name"; 
		
		override public function PopUpPanel()
		{
			super();
			_btnGroup = new ButtonGroup(this.mc_endPeriod, this.mc_hadSex, this.mc_startPeriod, this.mc_saveNote);
			_btnGroup.addEventListener(ButtonGroup.SELECTED, onChange);
			this.mc_closeNote.addEventListener(MouseEvent.CLICK, onCloseNote);
		}
		/**
		 * This function closes the PopUpPanel
		 * @param e:Mouse Event
		 * 
		 */		
		public function onCloseNote(e:MouseEvent):void
		{
			this.parent.removeChild(this);
		}
		private function onChange(e:Event):void
		{
			_selectedBox = _btnGroup.selectedBtn.name;
			var checkClickEvt:PopupEvent = new PopupEvent(PopupEvent.SELECT_BOX);
			checkClickEvt.btnname = _selectedBox;
			dispatchEvent(checkClickEvt);
		}
		public function get date():Date
		{
			return _date;
		}
		public function set date(value:Date):void
		{
			_date = value;
		}	
	}
}