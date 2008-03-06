package org.doc
{
	public final class PageFit
	{
		public static const NONE:uint = 0;
		public static const ACTUAL_PAGE_SIZE:uint = 1;
		public static const PAGE:uint = 2;
		public static const WIDTH:uint = 3;
		
		public static function asString(fitMode:uint):String {
			return fitMode == WIDTH ? "Fit Width" : fitMode == PAGE ? "Fit Page" : fitMode == ACTUAL_PAGE_SIZE ? "Actual Size" : "None";
		}
	}
}