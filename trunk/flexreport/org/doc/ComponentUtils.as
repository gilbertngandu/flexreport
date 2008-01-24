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
package org.doc {
	import flash.display.Bitmap;
	import mx.core.UIComponent;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import mx.core.Container;
	import flash.display.DisplayObject;
	import mx.core.IFlexDisplayObject;
	
	public class ComponentUtils {
		public function ComponentUtils() {
			
		}
		
		public static function captureComponent(source:UIComponent, width:Number):Bitmap
		{
			var scale:Number = width / source.width;
			var matrix:Matrix = new Matrix();
			var bd:BitmapData = new BitmapData( width, source.height * scale );
			
			matrix.scale( scale, scale );
			bd.draw( source, matrix );
					
			var result:Bitmap = new Bitmap(bd);
			
			return result;			
		}

		public static function duplicateComponent(source:UIComponent):UIComponent {
			var container:Container = new Container();
			var clone:IFlexDisplayObject = container.createComponentFromDescriptor(source.descriptor,true);
			
			return clone as UIComponent;
		}
	}
}