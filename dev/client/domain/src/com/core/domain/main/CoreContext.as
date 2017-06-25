package com.core.domain.main
{
    import com.core.domain.services.navigation.INavigationServices;
    import com.core.utils.Singleton;
    
    public class CoreContext
    {
        static public var ME:CoreContext;
        
        function CoreContext()
        {
            ME = Singleton.enforce(ME, this);
        }
        
        public var navigator:INavigationServices;
    }
}