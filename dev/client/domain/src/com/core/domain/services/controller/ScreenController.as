package com.core.domain.services.controller
{
    import com.core.domain.services.view.IView;
    
    public class ScreenController implements IScreenController
    {
        public function getView():IView
        {
            if (!view) throw new Error("view is null");
            return view;
        }
        
        private var view:IView;
        private var viewClass:Class;
        
        public function createView():IView
        {
            this.viewClass = getViewClass();
            return view = new viewClass().draw();
        }
        
        public function dispose():void
        {
            if (view) view.dispose();
        }
        
        public function getViewClass():Class
        {
            throw new Error("override me");
        }
    
        public function toString():String
        {
            throw new Error("override me");
        }
    }
}
