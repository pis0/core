package com.core.domain.services.view
{
    
    public interface IView
    {
        function dispose():void;
        function draw():IView;
        function toString():String;
    }
}
	