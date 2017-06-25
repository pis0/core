package com.core.view.starling.main
{
    import starling.display.Sprite;
    
    public class StarlingSprite extends Sprite
    {
        static public var spriteCallback:Function = null;
        
        function StarlingSprite()
        {
            if (spriteCallback != null) spriteCallback(this);
        }
        
    }
}
