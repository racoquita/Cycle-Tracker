package calendar
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * The Btn Group class handles the buttons/ selected states in the UI
	 * @author racoquita
	 * 
	 * @example How to use the BtnGroup
	 * <listing version = "3.0">
	 * _btnGrp = new ButtonGroup(this.mc_beaches, this.mc_mountains, this.mc_cities);
	 * </listing>
	 */	
	public class ButtonGroup extends EventDispatcher
	{
		private static var _selectedBtn:MovieClip;
		private var _mc:MovieClip;
		public static const SELECTED:String = "selected";
		/**
		 * 
		 * @param btn this is an array of buttons
		 * 
		 */		
		public function ButtonGroup(...btn)
		{
			super();
			
			for each(var button:MovieClip in btn)
			{
				button.stop();
				button.buttonMode = true;
				button.mouseChildren = false;
				button.addEventListener(MouseEvent.CLICK, onClick);
				//button.addEventListener(MouseEvent.ROLL_OVER, onOver)
				//button.addEventListener(MouseEvent.ROLL_OUT, onOut)
			}
		}
		/**
		 * This function handles what happens when the user clicks on the button
		 * @param e Mouse Event
		 * 
		 */		
		private function onClick(e:MouseEvent):void
		{
			if( e.currentTarget != _selectedBtn)
			{
				e.currentTarget.gotoAndStop(2);
				if(_selectedBtn !=null) _selectedBtn.gotoAndStop(1);
				_selectedBtn = MovieClip(e.currentTarget);
				this.dispatchEvent(new Event(ButtonGroup.SELECTED));
			}
		}
		private function onOver(e:MouseEvent):void
		{
			if(e.currentTarget.currentFrame == 1 ) e.currentTarget.gotoAndStop(2);
		}
		private function onOut(e:MouseEvent):void
		{
			if(e.currentTarget.currentFrame == 2 ) e.currentTarget.gotoAndStop(1);	
		}
		/**
		 * this function allows you to get the seleced button
		 * @return  the selected button
		 * 
		 */		
		public function get selectedBtn():MovieClip
		{
			return _selectedBtn;
		}

	}
}