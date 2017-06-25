package com.core.domain.services.controller
{
    import com.core.domain.services.view.IView;
    
    public interface IScreenController
    {
        function getView():IView;
        
        function createView():IView;
        
        function dispose():void;
        
        function getViewClass():Class;
        
        function toString():String;
        
        
    }
}
