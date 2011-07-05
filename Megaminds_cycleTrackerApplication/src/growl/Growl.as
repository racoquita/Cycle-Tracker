package growl
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	public class Growl extends Sprite
	{
		public function Growl()
		{
			super();
			
		}
		public static function sendGrowl(title:String,message:String):void
		{
			var process:NativeProcess;
			var file:File = File.applicationDirectory;
			file = file.resolvePath("growlNotify");
			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs[0] = "-n"
			processArgs[1] = "My AIR application";
			processArgs[2] = "-p"
			processArgs[3] = "0";
			processArgs[4] = "-t"
			processArgs[5] = title;
			processArgs[6] = "-m";
			processArgs[7] = message;
			processArgs[8] = "-a";
			processArgs[9] = "Cycle Tracker";
			trace(processArgs)
			nativeProcessStartupInfo.arguments = processArgs;
			nativeProcessStartupInfo.executable = file;
			
			process = new NativeProcess();
			process.start(nativeProcessStartupInfo);
		}
	}
}