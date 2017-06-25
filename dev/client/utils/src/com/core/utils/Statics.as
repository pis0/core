package com.core.utils
{
    import flash.display.Stage;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.ApplicationDomain;
    
    public class Statics
    {
        static public var STAGE:Stage = null;
        static public var VIEW_PORT:Rectangle = new Rectangle();
        static public var APPLICATION_DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
        
    }
}
