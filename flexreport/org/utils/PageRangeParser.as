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

package org.utils
{
	public class PageRangeParser
	{
			public static function parsePageRange(printRange: String):Array
			{
				const minPage:int = 1;
				const maxPage:int = 1000;
				var result:Array = new Array();
				var ranges:Array = printRange.split(/[,;]/);
				var page:int;
				
				for each (var range:String in ranges)
				{
					if (range.indexOf("-") >= 0) /* page range */
					{
						var first:int;
						var last:int;
						var pageRange:Array = range.split(/[-]/);
						if (pageRange.length == 2)
						{
							first = IntegerUtils.parseIntegerDefault(pageRange[0], -1);
							last = IntegerUtils.parseIntegerDefault(pageRange[1], -1);
							
							if ((first < minPage) || (first > last) || (last > maxPage))
								return null; /* error */
							
							for (page = first; page <= last; page++)
								if (result.indexOf(page) < 0)
									result.push(page);
								
						} else
							 return null; /* error */
					}
					else /* single page */
					{
						page = IntegerUtils.parseIntegerDefault(range, -1);
						if ((page >= minPage) && (page <= maxPage))
						{
							if ((result.indexOf(page) < 0))
								result.push(page);
						}
						else
							return null; /* error */
					}
				}
				return result.sort(Array.NUMERIC);
			}		
	}
}