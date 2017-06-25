package com.core.domain.services.navigation
{
    import com.core.domain.services.controller.ScreenController;
    
    public interface IScreen
    {
        function dispose():void;
        
        function get id():String;
        
        function get flag():uint;
        
        function setController(screenControllerClass:Class, autoCreateView:Boolean = false):void;
        
        function get controller():ScreenController;
        
        function get controllerClass():Class;
        
        function toString():String;
        
    }
}
