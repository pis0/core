package com.core.utils
{
    
    public class BitFlagUtils
    {
        
        static public function isSet(flags:uint, flagMask:uint):Boolean
        {
            return flagMask == (flags & flagMask);
        }
        
    }
    
}