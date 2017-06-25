package com.core.utils
{
    public class Singleton
    {
        static public function enforce(reference:*, instance:* = null):*
        {
            if (reference) throw new Error(instance != null ? instance : "?");
            return instance;
        }
    }
}
