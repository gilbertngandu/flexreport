package org.utils
{
	import flash.utils.ByteArray;
	
	public final class ByteArrayUtil
	{
		public function ByteArrayUtil()
		{
		}
		
		public static function clone(value:ByteArray):ByteArray {
			var myBA:ByteArray = new ByteArray();
		    myBA.writeObject(value);
		    myBA.position = 0;
		    
		    return myBA.readObject();
		}
	}
}