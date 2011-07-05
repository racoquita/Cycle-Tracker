package calendar
{
	import flash.events.MouseEvent;
	
	import libs.DisplayNote;
	
	public class DisplayNotePanel extends DisplayNote
	{
		public function DisplayNotePanel()
		{
			super();
			this.mc_closeNote.addEventListener(MouseEvent.CLICK, onCloseNote);
			this.btn_remove.addEventListener(MouseEvent.CLICK, onCloseNote);

			this.mc_closeNote.buttonMode = true;
			this.btn_remove.buttonMode = true;
			this.btn_remove.mouseChildren = false;
		}
		public function onCloseNote(e:MouseEvent):void
		{
			this.parent.removeChild(this);
		}
	}
}