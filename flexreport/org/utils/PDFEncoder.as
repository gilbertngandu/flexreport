package org.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.doc.Document;
	import org.doc.PaperFormat;
	
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
			var pdf:PDF = new PDF(Orientation.PORTRAIT, Unit.MM, _paperFormat.toSize());
			
			var pageCount:int = _pages.length;
			for (var i:int = 0; i < pageCount; i++) {
										
				/*BENCHMARK*/var start:Number = new Date().getTime();
				pdf.addPage();
				
				var pageBytes:ByteArray = ByteArrayUtil.clone(_pages[i]);
				pageBytes.uncompress();
				
				var bd:BitmapData = new BitmapData(_paperFormat.width*Document.PAGE_SCALE,_paperFormat.height*Document.PAGE_SCALE);
				
				bd.setPixels(new Rectangle(0,0,_paperFormat.width*Document.PAGE_SCALE,_paperFormat.height*Document.PAGE_SCALE),pageBytes);	
							
				var page:Bitmap = new Bitmap(bd);
				//page.smoothing = true;
				/*BENCHMARK*/var end1:Number = new Date().getTime();
				pdf.addImage(page);		
				/*BENCHMARK*/var end2:Number = new Date().getTime();
				/*BENCHMARK*/trace("uncompressImage: " + (end1-start) + " addPage:" + (end2-end1) + " time:" + (end2-start));				
			}
			
			pdf.savePDF(_method, _URL, _download, _name);							
		}
		
	}
}