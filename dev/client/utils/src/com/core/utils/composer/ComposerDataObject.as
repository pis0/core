package com.core.utils.composer
{
    public class ComposerDataObject extends Object
    {
        public var action:uint;
        public var data:Object;

        function ComposerDataObject()
        {
        }

        public function toString():String
        {
            return "[ComposerDataObject action:" + action + ", data:" + data + " ]";
        }
    }
}
