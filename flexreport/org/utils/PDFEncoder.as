package org.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.doc.PaperFormat;
	import org.print.Page;
	
	public class PDFEncoder extends EventDispatcher
	{
		private var _pages:Array;
		private var _paperFormat:PaperFormat;
		private var _loadedPages:Array = new Array();
		
		private var _method:String;
		private var _URL:String;
		private var _download:String;
		private var _name:String;
		
		public function PDFEncoder(pages:Array, paperFormat:PaperFormat, pMethod:String, pURL:String='', pDownload:String='inline', pName:String='generated.pdf')
		{
			_pages = pages;
			_paperFormat = paperFormat;
			
			_method = pMethod;
			_URL = pURL;
			_download = pDownload;
			_name = pName;
		}
		
		public function encode():void {
			var pageCount:int = _pages.length;
			for (var i:int = 0; i < pageCount; i++) {
				var page:Page = new Page();
				page.number = i+1;
				_loadedPages.push(page);
				
				page.addEventListener(Event.COMPLETE,pageLoadedHandler);
				
				page.source = _pages[i];
				page.paperFormat = _paperFormat;		
			}
		}
		
		private var _loadCount:int = 0;
		private function pageLoadedHandler(event:Event):void {
			_loadCount++;
			var pageCount:int = _pages.length;
			
			if(_loadCount===pageCount) {
				var pdf:PDF = new PDF ( Orientation.PORTRAIT, Unit.MM, Size.A4 );

				for (var i:int = 0; i < pageCount; i++) {
					pdf.addPage();

					var page:Page = _loadedPages[i] as Page;
					
					var pageSnapshotBMP:Bitmap = new Bitmap(page.bitmapData);		
					pageSnapshotBMP.smoothing = true;
					
					var scale:Number = PaperFormat.A4.width / page.bitmapData.width;
					var matrix:Matrix = new Matrix();
					var bd:BitmapData = new BitmapData( PaperFormat.A4.width, PaperFormat.A4.height, false );
		
					matrix.scale( scale, scale );
					bd.draw( pageSnapshotBMP, matrix );
							
					pdf.addImage(new Bitmap(bd));					
				}
				pdf.savePDF(_method, _URL, _download, _name);				
			}
		}
	}
}