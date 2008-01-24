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
 * 
 */
 
 package org.doc
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.printing.FlexPrintJob;
	
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Download;
	import org.alivepdf.saving.Method;
	
	public class Document
	{
		private var _template:Object;
		private var _pages:Array = new Array();
		private var _thumbs:Array = new Array();
		[Bindable]
		public var currentPage:Bitmap;
		
		[Bindable]
		public var pageNumber:int = 1;
		
		public function Document(template:String, dataProvider:Object) {
			var classReference:Class = getDefinitionByName(template) as Class;
			_template = new classReference();
 			_template.initialize();
			
			_template.dataProvider = dataProvider; 
			_template.invalidateDisplayList();
			
			capturePages();
			
			if(_template.hasOwnProperty("title")) {
				title = _template.title;
			}
			else {
				title="untitled";
			}
		}
		
		public function get template():DisplayObject  {
			
			var tmp:DisplayObject = _template as DisplayObject;
			tmp.visible = false;
			return tmp;
		}
		
		public function capturePages():void {
			Application.application.addChild(template);
			
			_template.validateNow();
			_template.reset();
			do {
				_pages.push(getBitmap(_template as UIComponent));
				_thumbs.push(getThumb(_template as UIComponent));
			} while(_template.nextPage());
			
			Application.application.removeChild(template);
			
			/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */
			/* currentPage = _pages[0] as Bitmap; */
			currentPage = new Bitmap((_pages[0] as Bitmap).bitmapData.clone());
			
			dispatchEvent(new Event("pageCountChanged"));
		}
			
		private function getBitmap(target:UIComponent):Bitmap
		{
			var bd:BitmapData = new BitmapData(target.width,target.height);
			var m:Matrix = new Matrix();
			bd.draw(target,m);
			
			var result:Bitmap = new Bitmap(bd);
			
			return result;
		}		
		
		private static const THUMB_WIDTH:Number = 77;	
		private function getThumb(target:UIComponent):Bitmap
		{
			var scale:Number = THUMB_WIDTH / target.width;
			var matrix:Matrix = new Matrix();
			var bd:BitmapData = new BitmapData( THUMB_WIDTH, target.height * scale );

			matrix.scale( scale, scale );
			bd.draw( target, matrix );
					
			var result:Bitmap = new Bitmap(bd);
			
			return result;			
		}
		
		
		public function doPrint():void {
            var printJob:FlexPrintJob = new FlexPrintJob();
            printJob.printAsBitmap = false;
                       
			if (printJob.start()) {
				_template.reset();
				Application.application.addChild(template);
				
				do {
					printJob.addObject(_template as UIComponent);
				} while(_template.nextPage());
				
				Application.application.removeChild(template);
				printJob.send();
				
			}                   		
		}
	    
	    private function addObject(printJob:FlexPrintJob, object:UIComponent):void {
	    	printJob.addObject(object);
	    }
	    
	    public var pdfEnabled:Boolean = true;
	    public var pdfScript:String = "";
		public function generatePDF():void {
			if(pdfScript!="") {
				if(pdfEnabled) {
					var myPDFEncoder:PDF = new PDF ( Orientation.PORTRAIT, Unit.MM, Size.A4 );
	
					/*
					_template.reset();
					Application.application.addChild(template);
					
					do {
						_template.validateNow();
						myPDFEncoder.addPage();
						myPDFEncoder.addImage(_template as DisplayObject);
					} while(_template.nextPage());
					
					Application.application.removeChild(template);
					*/
					
					for(var i:int=0;i<pageCount;i++) {
						myPDFEncoder.addPage();
						/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */						
						/* myPDFEncoder.addImage(_pages[i]); */
						myPDFEncoder.addImage(new Bitmap((_pages[pageNumber-1] as Bitmap).bitmapData.clone()));						
					}
					myPDFEncoder.savePDF ( Method.REMOTE, pdfScript, Download.ATTACHMENT, title + ".pdf" );        
				} else {
					Alert.show("This feature is disabled!");
				}
			}             		
		}
		
		public function enqueue(printJob:FlexPrintJob):void {
			Application.application.addChild(template);
			_template.validateNow();
			_template.reset();
			do {
				printJob.addObject(_template as UIComponent);
			} while(_template.nextPage());
			Application.application.removeChild(template);                     		
		}
				
		public function nextPage():void {
			if(pageNumber < _pages.length) {
				pageNumber++;
				/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */
				/* currentPage = _pages[pageNumber-1]; */
				currentPage = new Bitmap((_pages[pageNumber-1] as Bitmap).bitmapData.clone());
				
			}
		}

		public function previousPage():void {
			if(pageNumber>1) {
				pageNumber--;
				/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */
				/* currentPage = _pages[pageNumber-1]; */
				currentPage = new Bitmap((_pages[pageNumber-1] as Bitmap).bitmapData.clone());
				
			}
		}
		
		public function goto(page:int):int {
			if(page>0&&page<=pageCount) {
				/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */
				/* currentPage=_pages[page-1]; */
				currentPage = new Bitmap((_pages[page-1] as Bitmap).bitmapData.clone());
				pageNumber = page;
			}
			
			return pageNumber;
		}
			
		[Bindable(event="pageCountChanged")]
		public function get pageCount():int {
			return _pages.length;
		}
				
		public function get pages():Array {
			var result:Array = new Array();
			for(var i:int=0;i<_pages.length;i++) {
				/* FIX: BITMAPDATA=NULL IN FLEX BUILDER 3  */
				/* var page:Bitmap = _pages[i] as Bitmap; */
				var page:Bitmap = new Bitmap((_pages[i] as Bitmap).bitmapData.clone());			
				result.push(new Bitmap(page.bitmapData));
			}
			return result;
		}

		public function get thumbs():Array {
			var result:Array = new Array();
			for(var i:int=0;i<_pages.length;i++) {
				var page:Bitmap = _thumbs[i] as Bitmap;
				result.push(new Bitmap(page.bitmapData));
			}
			return result;
		}
		
		[Bindable] public var title:String;
		
		[Bindable]
		public var checked:Boolean=false;
	}
}