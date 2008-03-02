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
 */ 

package org.doc
{
	public class PaperFormat
	{
		public static const A0 : PaperFormat = new PaperFormat(841, 1189);
		public static const A1 : PaperFormat = new PaperFormat(594, 841);
		public static const A2 : PaperFormat = new PaperFormat(420, 594);
		public static const A3 : PaperFormat = new PaperFormat(297, 420);
		public static const A4 : PaperFormat = new PaperFormat(210, 297);
		public static const A5 : PaperFormat = new PaperFormat(148, 210);
		public static const Letter : PaperFormat = new PaperFormat(215.9, 279.4);
		public static const Legal : PaperFormat = new PaperFormat(215.9, 355.6);
		
		private var _width : Number;
		private var _height : Number;
		
		public function get width() : Number
		{
			return _width;
		}

		public function get height() : Number
		{
			return _height;
		}
		
		public function get scale() : Number
		{
			return _height / _width;
		}
		
		public function PaperFormat(width : Number, height : Number) : void
		{
			_height = height;
			_width = width;
		}
	}
}