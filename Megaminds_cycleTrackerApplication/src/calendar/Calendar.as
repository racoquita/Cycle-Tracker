package calendar
{
	import calendar.events.SelectDayEvent;
	import calendar.vo.CalEventVO;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import growl.Growl;
	
	import libs.Box;
	import libs.CalendarBase;
	
	/**
	 * The Calendar class is responsible for getting the information from the Main and displaying it 
	 * @author racoquita
	 * 
	 */	
	public class Calendar extends CalendarBase
	{
		private var _currentDate:Date;
		private var _monthsOfYear:Array;
		private var _daysOfMonths:Array;
		private var _chosenMonthToDisplay:Date;
		private var _squaresHolder:MovieClip;
		private var _startDay:int = 0;
		private var _checkedBox:String;
		private var _daysArray:Array;
		private var _selectedDay:DateSquare;
		private var _selectDate:String;
		private var _selDate:Date;
		private var _xDate:Date = new Date();
		private var square:DateSquare
		private var _currentMonth:uint
		private var _popPanel:PopUpPanel;
		private var _voArr:Array
		private var _vo:CalEventVO;
		
		public function Calendar() 
		{
			_vo = new CalEventVO();
			super();
			initControls();
		}
		private function initControls():void
		{
			this.lM_mc.addEventListener(MouseEvent.MOUSE_DOWN, onPrevMonth);
			this.nM_mc.addEventListener(MouseEvent.MOUSE_DOWN, onNextMonth);
			this.nM_mc.buttonMode = true;
			this.lM_mc.buttonMode = true;
		}
		/**
		 * This function runs when the user clicks on a date
		 * It adds the pop-up panel with the options to add to the calendar and dispatches the date that has been selected
		 * @param e:MouseEvent
		 * 
		 */		
		private function onDateClick(e:MouseEvent):void
		{
			_popPanel = new PopUpPanel();
			_popPanel.date = e.currentTarget.date;
			this.parent.addChild(_popPanel);
			_popPanel.addEventListener(PopupEvent.SELECT_BOX, checkSelCheckBox);
		
			_selectedDay = DateSquare(e.currentTarget);
			_selDate = e.currentTarget.date;
			_selDate.month = e.currentTarget.month;
			this.dispatchEvent(new Event(Event.SELECT));
		}
		public function getDatum():Date
		{
			return _selDate;
		}
		/**
		 * This function updates the calendar and it is called from the main
		 * The function lays out the squares of the calendar and creates value objects for each of the event types
		 * @param month:int
		 * @param voArr: Array
		 * 
		 */		
		public function update(month:int, voArr:Array):void
		{	
			_voArr = voArr
			_currentDate = new Date();
			_monthsOfYear = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
			_daysOfMonths = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31); 
		
			//TODO: By this logic, you can't view periods next year.
			_chosenMonthToDisplay = new Date(_currentDate.getFullYear(),month);
			_startDay = _chosenMonthToDisplay.getDay();
			
			updateTextFields();
			//this.month_txt.text = _monthsOfYear[_chosenMonthToDisplay.month]  +" " + _chosenMonthToDisplay.fullYear ;
			
			
			var row:Number = 0;
			if(_squaresHolder && this.contains(_squaresHolder)) this.removeChild(_squaresHolder);
			_squaresHolder = new MovieClip;
			addChild(_squaresHolder);
			_squaresHolder.x = 35;
			_squaresHolder.y = 10;
			
			for (var i:int = 0; i < getDays(_chosenMonthToDisplay); i++) 
			{
				var mm:uint = _chosenMonthToDisplay.getMonth();
				var yy:uint = _chosenMonthToDisplay.getFullYear();
				square = new DateSquare();
				square.stop();
				_squaresHolder.addChild(square);
				square.date = new Date(yy,mm,i+1);
				square.x =  _startDay  * 75;
				square.y = (row + 1.61) * 65;
				_startDay++;
				if(_startDay >= 7)
				{
					_startDay = 0;
					row++;
				}
				square.addEventListener(MouseEvent.CLICK, onDateClick);
				square.buttonMode = true;
				square.addEventListener(MouseEvent.MOUSE_OVER, onDateHover);
				square.addEventListener(MouseEvent.MOUSE_OUT, onDateHoverOut);
				
				
				for each( var evt:Object in voArr)
				{
					if(evt.content)
					{
						_vo.content = evt.content;
					}
					_vo.date = evt['date'];
					_vo.type = evt['type'];
					//if the date of the VO matches the date of square 
					if(evt.date.valueOf() == square.date.valueOf())
					{
					
						//trace("ADDING EVENT ",evt.type, " " + evt.date.toDateString(), "Event " + voArr.indexOf(evt) + " of " + voArr.length)
						if(evt.type == CalEventVO.START_PERIOD)
						{
							var startPeriodIcon:PeriodIcon = new PeriodIcon();
							startPeriodIcon.y = 30;
							startPeriodIcon.x = 46;
							startPeriodIcon.data = evt;
							square.addChild(startPeriodIcon);
							startPeriodIcon.buttonMode = true;
							startPeriodIcon.addEventListener(MouseEvent.CLICK, onCalVoClick);
							
						}else if(evt.type == CalEventVO.END_PERIOD)
						{
							var endPeriodIcon:EndPeriodIcon = new EndPeriodIcon();
							endPeriodIcon.y = 30;
							endPeriodIcon.x = 46;
							endPeriodIcon.data = evt;
							square.addChild(endPeriodIcon);
							endPeriodIcon.buttonMode = true;
							endPeriodIcon.addEventListener(MouseEvent.CLICK, onCalVoClick);
							
						}else if(evt.type == CalEventVO.HAD_SEX)
						{
							var hadSexIcon:HadSexIcon = new HadSexIcon();
							hadSexIcon.y = -20;
							hadSexIcon.x = 28;
							hadSexIcon.data = evt;
							square.addChild(hadSexIcon);
							hadSexIcon.buttonMode = true;
							hadSexIcon.addEventListener(MouseEvent.CLICK, onCalVoClick);	
						}
						if(evt.type == CalEventVO.ADD_NOTE)
						{
							var noteIcon:NoteIcon = new NoteIcon();
							noteIcon.y = 30;
							noteIcon.x = 26;
							noteIcon.data = evt;
							square.addChild(noteIcon);
							noteIcon.buttonMode = true;
							noteIcon.addEventListener(MouseEvent.CLICK, onCalVoClick);
						}
					}
				}	
			}
			updateXML();
		}
		/**
		 * This function dispatches an Event to the main when the user clicks the arrow for the previous month
		 * @param e:MouseEvent
		 * 
		 */		
		private function onPrevMonth(e:MouseEvent):void
		{
			dispatchEvent(new SelectDayEvent(SelectDayEvent.PREV_MONTH));
			
		}                   
		private function onNextMonth(e:MouseEvent):void
		{
			dispatchEvent(new SelectDayEvent(SelectDayEvent.NEXT_MONTH));
			
		}
		private function updateTextFields():void
		{
		
			this.month_txt.text = _monthsOfYear[_chosenMonthToDisplay.month] +" " + _chosenMonthToDisplay.fullYear;
			
		}
		private function onCalVoClick(e:MouseEvent):void
		{
			if(e.currentTarget.data.type == CalEventVO.ADD_NOTE)
			{
				var showNoteP:DisplayNotePanel = new DisplayNotePanel();
				if(showNoteP && parent.contains(showNoteP)) this.parent.removeChild(showNoteP);
				showNoteP.x = this.x + 20;
				showNoteP.y = this.height/2;
				parent.addChild(showNoteP);
				showNoteP.tf_showNote.text = e.currentTarget.data.content;
				showNoteP.btn_remove.addEventListener(MouseEvent.CLICK, onDelNote);
				
			} else if(e.currentTarget.data.type == CalEventVO.END_PERIOD ||e.currentTarget.data.type == CalEventVO.START_PERIOD || e.currentTarget.data.type == CalEventVO.HAD_SEX ){
				
				if(delOptionPanel && this.parent.contains(delOptionPanel)) this.parent.removeChild(delOptionPanel);
			
				var delOptionPanel:DeleteOptionPanel = new DeleteOptionPanel();
				//_vo = e.currentTarget.data
				delOptionPanel.vo  = e.currentTarget.data as CalEventVO;
				delOptionPanel.x = this.x + delOptionPanel.width/2;
				delOptionPanel.y = this.height/2 - delOptionPanel.height/2;
				parent.addChild(delOptionPanel);
				delOptionPanel.addEventListener(Event.SELECT, onDelNote);
				delOptionPanel.btn_yes.addEventListener(MouseEvent.CLICK, onDelNote);
				//_vo = e.currentTarget.data as CalEventVO
			}
			
			if((e.currentTarget.data).content)
			{
				_vo.content = (e.currentTarget.data).content;
			}
			_vo.date = (e.currentTarget.data).date;
			_vo.type = (e.currentTarget.data).type;
			e.stopPropagation();
		}
		private function onDelNote(e:MouseEvent):void
		{
			var removeEvt:SelectDayEvent = new SelectDayEvent(SelectDayEvent.REM_VO);
			removeEvt.vo = _vo;
			dispatchEvent(removeEvt);
			e.stopPropagation();
		}
		/**
		 * This functions checks what option in the PopuoPanel has been selected
		 * @param e:PopupEvent
		 * 
		 */		
		private function checkSelCheckBox(e:PopupEvent):void
		{
			if(e.btnname == "mc_saveNote")
			{
				var addedNoteVO:CalEventVO = new CalEventVO();
				addedNoteVO.date = e.currentTarget.date;
				addedNoteVO.type = CalEventVO.ADD_NOTE;
				addedNoteVO.content =  _popPanel.tf_note.text;
			
				var addedNoteEvent:PopupEvent = new PopupEvent(PopupEvent.ADD_EVENT);
				addedNoteEvent.eventData = addedNoteVO;
				this.dispatchEvent(addedNoteEvent);
			}
			_checkedBox = e.btnname;
			if(_checkedBox == "mc_startPeriod") 
			{
				var calvoStartPeriod:CalEventVO = new CalEventVO();
				calvoStartPeriod.date = e.currentTarget.date;
				calvoStartPeriod.type = CalEventVO.START_PERIOD;
				
				var startPeriodEvent:PopupEvent = new PopupEvent(PopupEvent.ADD_EVENT);
				startPeriodEvent.eventData = calvoStartPeriod;
				this.dispatchEvent(startPeriodEvent);
			}
			if(_checkedBox == "mc_endPeriod") 
			{
				var calvoEndPeriod:CalEventVO = new CalEventVO();
				calvoEndPeriod.date = e.currentTarget.date;
				calvoEndPeriod.type = CalEventVO.END_PERIOD;
				
				var endPeriodEvent:PopupEvent = new PopupEvent(PopupEvent.ADD_EVENT);
				endPeriodEvent.eventData = calvoEndPeriod;
				this.dispatchEvent(endPeriodEvent);
			}
			if(_checkedBox == "mc_hadSex")
			{
				var calvohadSex:CalEventVO = new CalEventVO();
				calvohadSex.date = e.currentTarget.date;
				calvohadSex.type = CalEventVO.HAD_SEX;
				
				var hadSexEvent:PopupEvent = new PopupEvent(PopupEvent.ADD_EVENT);
				hadSexEvent.eventData = calvohadSex;
				this.dispatchEvent(hadSexEvent);
			}
			PopUpPanel(e.currentTarget).onCloseNote(null);
			
		}
		private function updateXML():void
		{
			var f:File = File.applicationStorageDirectory;
			f.nativePath += File.separator + "CycleTracker";
			trace(f.nativePath);
			
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeObject(_voArr);
			fs.close();
			
			var fs2:FileStream = new FileStream();
			fs2.open(f,FileMode.READ);
			var readObject:Array = fs2.readObject() as Array;
			fs2.close();
			trace(readObject);
		}

		/**
		 * The getDays function handles the leap year
		 * @param date: Date 
		 * @return uint 
		 * 
		 */		
		private function getDays(date:Date):uint 
		{
			return (date.getFullYear()%4 == 0 && date.getMonth() == 1 ? 29 : _daysOfMonths[date.getMonth()]);
		}
		/**
		 * This function handles the over state of the Date
		 * @param e:MouseEvent
		 * 
		 */		
		private function onDateHoverOut(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(1);
		}
		private function onDateHover(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(5);
		}
	}
}