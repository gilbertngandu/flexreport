/*
 * ============================================================================
 * GNU Lesser General Public License
 * ============================================================================
 *
 * FlexReport - Free Flex report-generating library.
 * Copyright (C) 2008 Frederico Garcia
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 * 
 * Frederico Garcia
 * fmotagarcia@kemelyon.com
 * http://www.kemelyon.com
 */
 
/*
 * Contributors:
 * Michal Wojcik (Michal.Wojcik@sabre.com)
 * Sylwester Bajek (Sylwester.Bajek@sabre.com)
 */
 
 package org.doc
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.printing.FlexPrintJob;
	
	import org.alivepdf.saving.Download;
	import org.alivepdf.saving.Method;
	import org.print.Report;
	import org.utils.PDFEncoder;
	import org.utils.PageRangeManager;
	
	public class Document
	{
		public static const PAGE_SCALE:Number = 1;
		
		private var _template:Report;
		private var _pages:Array = new Array();
		private var _thumbs:Array = new Array();
		[Bindable]
		public var currentPage:*;
		
		[Bindable]
		public var pageNumber:int = 2;
		
		private var _templateName : String; 
		private var _dataProvider : Object;
		private var _paperFormat  : PaperFormat;
		
		private var _pageRangeManager : PageRangeManager = new PageRangeManager(PageRangeManager.ALL);
		 		
		public function Document(template:String, dataProvider:Object, paperFormat : PaperFormat = null):void
		{
			_dataProvider = dataProvider;
			_templateName = template;
			
			_paperFormat = paperFormat;
			
			createTemplate();
			capturePages();
			
			title = _template.title;
		}
		
		public function get paperFormat():PaperFormat {
			return _paperFormat;
		}
		
		public function createTemplate() : void
		{
			var classReference:Class = getDefinitionByName(_templateName) as Class;
			
			_template = new classReference();
 			_template.initialize();
			_template.dataProvider = _dataProvider; 
			_template.invalidateDisplayList();
			
 			if (_paperFormat != null) 			
 				_template.height = _template.width * _paperFormat.scale; 
		}
		
		public function get template():DisplayObject
		{
			var tmp:DisplayObject = _template as DisplayObject;
			tmp.visible = false;
			return tmp;
		}
		
		public function set pageRangeManager(value : PageRangeManager) : void
		{
			_pageRangeManager = value;
		}
		
		public function capturePages():void
		{
			Application.application.addChild(template);
			
			_template.validateNow();
			_template.reset();

			do {
				_pages.push(getSnapshot(_template as UIComponent));
				_thumbs.push(getThumb(_template as UIComponent));
			} while (_template.nextPage());

			Application.application.removeChild(template);
			
			currentPage = clone(_pages[0]);
			dispatchEvent(new Event("pageCountChanged"));
		}
				
		private function getSnapshot(target:UIComponent):ByteArray {		
			var bd:BitmapData = new BitmapData(target.width*PAGE_SCALE, target.height*PAGE_SCALE, false);
			var m:Matrix = new Matrix();
			
			m.scale(PAGE_SCALE,PAGE_SCALE);
			bd.draw(target,m);
			
			/*BENCHMARK*/var start:Number = new Date().getTime();
			var bytes:ByteArray = bd.getPixels(new Rectangle(0,0,target.width*PAGE_SCALE,target.height*PAGE_SCALE));
			/*BENCHMARK*/var uncompressedSize:uint = bytes.length;
			bytes.compress();
			/*BENCHMARK*/var compressedSize:uint = bytes.length;
			/*BENCHMARK*/var end1:Number = new Date().getTime();
			/*BENCHMARK*/trace("uncompressedSize: " + uncompressedSize + " compressedSize:" + compressedSize + " time:" + (end1-start));
			return bytes;
		}
		
		private static const THUMB_WIDTH:Number = 77;
		
		private function getThumb(target:UIComponent):Bitmap
		{
			var scale:Number = THUMB_WIDTH / target.width;
			var matrix:Matrix = new Matrix();
			var bd:BitmapData = new BitmapData( THUMB_WIDTH, target.height * scale, false );

			matrix.scale( scale, scale );
			bd.draw( target, matrix );
					
			var result:Bitmap = new Bitmap(bd);
			
			return result;			
		}
		
		
		public function doPrint():void
		{
            var printJob:FlexPrintJob = new FlexPrintJob();
            printJob.printAsBitmap = false;
                       
			if (printJob.start()) {
				createTemplate();
				Application.application.addChild(template);
				_template.validateNow();
				_template.reset();
				
				do {
					if (_pageRangeManager.canPrint(_template.pageNumber))
						printJob.addObject(_template as UIComponent);
				} while(_template.nextPage());
				
				Application.application.removeChild(template);
				printJob.send();
			}                   		
		}
	    
	    private function addObject(printJob:FlexPrintJob, object:UIComponent):void
	    {
	    	printJob.addObject(object);
	    }
	    
	    public var pdfEnabled:Boolean = true;
	    public var pdfScript:String = "";
	    
		public function generatePDF():void
		{
			if (pdfScript !== "") {
				if (pdfEnabled) {
					var pdfEncoder:PDFEncoder = new PDFEncoder(_pages,paperFormat,Method.REMOTE, pdfScript, Download.ATTACHMENT, title + ".pdf" );
					pdfEncoder.encode();
					
				} else {
					Alert.show("This feature is disabled!");
				}
			}             		
		}
		
		public function enqueue(printJob:FlexPrintJob):void
		{
			Application.application.addChild(template);
			_template.validateNow();
			_template.reset();
			do {
				printJob.addObject(_template as UIComponent);
			} while(_template.nextPage());
			Application.application.removeChild(template);                     		
		}
				
		public function nextPage():void
		{
			if (pageNumber < _pages.length) {
				pageNumber++;

				currentPage = clone(_pages[pageNumber-1]);
			}
		}

		public function previousPage():void
		{
			if (pageNumber > 1) {
				pageNumber--;
				
				currentPage = clone(_pages[pageNumber-1]);
			}
		}
		
		public function goto(page:int):int
		{
			if (page > 0 && page <= pageCount) {
				currentPage = clone(_pages[page-1]);
				
				pageNumber = page;
			}
			
			return pageNumber;
		}
			
		[Bindable(event="pageCountChanged")]
		public function get pageCount():int {
			return _pages.length;
		}
				
		public function get pages():Array
		{
			var result:Array = new Array();
			for (var i:int = 0; i < _pages.length; i++) {
				result.push(clone(_pages[i]));
			}
			return result;
		}

		public function get thumbs():Array
		{
			var result:Array = new Array();
			for (var i:int = 0; i < _pages.length; i++) {
				var page:Bitmap = _thumbs[i] as Bitmap;
				result.push(new Bitmap(page.bitmapData));
			}
			return result;
		}
		
		[Bindable] public var title:String;
		
		[Bindable]
		public var checked:Boolean = false;
		
		private function clone(source:Object):*{
		    var myBA:ByteArray = new ByteArray();
		    myBA.writeObject(source);
		    myBA.position = 0;
		    return myBA.readObject();
		}
	}
}