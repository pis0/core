package com.core.domain.services.navigation
{
    public interface INavigationServices
    {
        
        function initiate():void;
        
        function get state():uint;
        
        function set state(value:uint):void;
        
    }
}
