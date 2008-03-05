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
	public class PaperFormat
	{
		/* EU */
		public static const A0 : PaperFormat = new PaperFormat([2384, 3370],"A0",[33.1,46.81],[841,1189]);
		public static const A1 : PaperFormat = new PaperFormat([1684, 2384],"A1",[23.39,33.11],[594,841]);
		public static const A2 : PaperFormat = new PaperFormat([1191, 1684],"A2",[16.54,23.39],[420,594]);
		public static const A3 : PaperFormat = new PaperFormat([842, 1191],"A3",[11.9,16.5],[297,420]);
		public static const A4 : PaperFormat = new PaperFormat([595, 842],"A4",[8.27,11.9],[210,297]);
		public static const A5 : PaperFormat = new PaperFormat([420, 595],"A5",[5.83,8.27],[148,210]);
		
		public static const A0R : PaperFormat = new PaperFormat([2384, 3370],"A0.Rotated",[33.1,46.81],[841,1189]);
		public static const A1R : PaperFormat = new PaperFormat([1684, 2384],"A1.Rotated",[23.39,33.11],[594,841]);
		public static const A2R : PaperFormat = new PaperFormat([1191, 1684],"A2.Rotated",[16.54,23.39],[420,594]);
		public static const A3R : PaperFormat = new PaperFormat([842, 1191],"A3.Rotated",[11.9,16.5],[297,420]);
		public static const A4R : PaperFormat = new PaperFormat([595, 842],"A4.Rotated",[8.27,11.9],[210,297]);
		public static const A5R : PaperFormat = new PaperFormat([420, 595],"A5.Rotated",[5.83,8.27],[148,210]);
		
		/* US */
		public static const LEGAL : PaperFormat = new PaperFormat([612, 1008],"Legal",[8.5,14],[215.9,355.6]);
		public static const LEGALR : PaperFormat = new PaperFormat([612, 1008],"Legal.Rotated",[8.5,14],[215.9,355.6]);

		public static const LETTER : PaperFormat = new PaperFormat([612, 792],"Letter",[8.5,11],[215.9,279.4]);
		public static const LETTERR : PaperFormat = new PaperFormat([612, 792],"Letter.Rotated",[8.5,11],[215.9,279.4]);
		
		public static const TABLOID : PaperFormat = new PaperFormat([792, 1224],"Tabloid",[11,17],[279.4,431.8]);
		public static const TABLOIDR:PaperFormat = new PaperFormat([792, 1224],"Tabloid.Rotated",[11,17],[279.4,431.8]);
				
		public function get width() : Number
		{
			return dimensions[0];
		}

		public function get height() : Number
		{
			return dimensions[1];
		}
		
		public function get scale() : Number
		{
			return height / width;
		}
		
		/**
		 * An array containing all the available paper sizes.
		 **/
		public static var paperFormats:Array = new Array(A3,A4,A5,LETTER,LEGAL,TABLOID);

		/**
		 * The dimensions used by the PDF engine to determine page extents.
		 **/
		public var dimensions:Array;

		/**
		 * A friendly label for users.
		 **/
		public var label:String = "";
		/**
		 * The dimensions, in inches.  This should be used for a friendly display for
		 * users and not in dimension calculations.
		 */
		public var inchesSize:Array;
		/**
		 * The dimensions, in mm.  This should be used for a friendly display for
		 * users and not in dimension calculations.
		 */
		public var mmSize:Array;
				
		/**
		 * Given a String representing the label of a size, or a Size object, this
		 * returns the Size object that corresponds to it.  Returns null on invalid
		 * size.
		 **/
		public static function getPaperFormat( value:Object ) : PaperFormat
		{
			if( value is PaperFormat ) { return PaperFormat ( value ); }
			
			if( value is String )
			{
				for each (var s:PaperFormat in paperFormats )
				{
					if( s.label == ( String (value) ) )
					{
						return s;
					}
				}
			}
			return null;
		}
				
		public function get fullLabel() : String
		{
			//Returns format like: Letter - 8.5"x11" - 216x356mm
			return label + " - " + inchesSize[0] + "x" + inchesSize[1] + "\" - " + mmSize[0] + "x" + mmSize[1] + "mm";
		}
						
		public function PaperFormat( pPixelsSize:Array, pLabel:String, pInchesSize:Array, pMmSize:Array ) : void
		{
			this.dimensions = pPixelsSize;
			this.label = pLabel;
			this.inchesSize = pInchesSize;
			this.mmSize = pMmSize;
		}
	}
}