package calendar
{
	import flash.events.MouseEvent;
	
	import libs.MyCheckBox;
	
	public class CheckBox extends MyCheckBox
	{
		private var _isSelected:Boolean;
		private var _cName:String;
		
		public function CheckBox()
		{
			super();
			this.stop();
			this.bg.stop();
			
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			bg.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			bg.addEventListener(MouseEvent.MOUSE_UP, onUp);
			bg.addEventListener(MouseEvent.MOUSE_OUT, onUp);
		}
		public function onClick(e:MouseEvent):void
		{
			
			if(this.currentFrameLabel == "on")
			{
				this.gotoAndStop("off");
			}else{
				this.gotoAndStop("on");
			}
			var checkEvt:PopupEvent = new PopupEvent(PopupEvent.CHANGE_NAME);
			checkEvt.btnname = _cName;
			dispatchEvent(checkEvt);
			
		}
		private function onOver(e:MouseEvent):void
		{
			this.bg.gotoAndStop("over");
		}
		private function onUp(e:MouseEvent):void
		{
			this.bg.gotoAndStop("up");	
		}
		private function onDown(e:MouseEvent):void
		{
			this.bg.gotoAndStop("down");
		}
		public function get isSelected():Boolean
		{
			if(currentLabel =="on"){ return true}
			else {return false}
		}
		public function set isSelected(select:Boolean):void
		{
			_isSelected = select;
			
			trace(select);
			if(_isSelected == false)
				{
					this.gotoAndStop("off");
				}else{
					this.gotoAndStop("on");
				}
		}

		public function get cName():String
		{
			return _cName;
		}

		public function set cName(value:String):void
		{
			_cName = value;
		}

		
	}
}