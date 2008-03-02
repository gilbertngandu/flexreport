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

package org.events
{
	import flash.events.Event;
	import org.utils.PageRangeManager;

	public class PageRangeEvent extends Event
	{
		public static const PAGE_RANGE_EVENT : String = "PAGE_RANGE_EVENT";
		
		private var _PageRange : PageRangeManager;
		
		public function PageRangeEvent(pageRange : PageRangeManager)
		{
			super(PAGE_RANGE_EVENT);
			_PageRange = pageRange;
		}
		
		public function get PageRange() : PageRangeManager
		{
			return _PageRange;
		}
	}
}