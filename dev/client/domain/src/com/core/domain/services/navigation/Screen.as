package com.core.domain.services.navigation
{
    import com.core.domain.services.controller.ScreenController;
    import com.core.utils.Utils;
    
    public class Screen implements IScreen
    {
        private var screenController:ScreenController;
        
        private var idd:String;
        
        public function get id():String
        {
            return this.idd;
        }
        
        private var flagg:uint;
        
        public function get flag():uint
        {
            return this.flagg;
        }
        
        public function Screen(id:String, flag:uint = 0)
        {
            this.idd = id;
            this.flagg = flag;
        }
        
        public function dispose():void
        {
            if (screenController)
            {
                Utils.print("dispose: " + this);
                
                screenController.dispose();
                screenController = null;
            }
            
        }
        
        private var screenControllerClass:Class;
        private var autoCreateView:Boolean;
        
        public function setController(screenControllerClass:Class, autoCreateView:Boolean = false):void
        {
            this.screenControllerClass = screenControllerClass;
            this.autoCreateView = autoCreateView;
            if (autoCreateView) initiateController();
        }
        
        public function get controllerClass():Class
        {
            if (!screenControllerClass) throw new Error("screenControllerClass is null");
            return screenControllerClass;
        }
        
        public function get controller():ScreenController
        {
//            if (!screenController) throw new Error("screenController is null");
            return screenController;
        }
        
        private function initiateController():void
        {
            if (screenController) screenController.dispose();
            screenController = new screenControllerClass(autoCreateView);
            
            Utils.print("Screen.initiateController:" + this);
        }
        
        public function toString():String
        {
            return "[Screen(id=" + id + ", screenController:" + screenController + ", autoCreateView:" + autoCreateView + ")]";
        }
    }
}
