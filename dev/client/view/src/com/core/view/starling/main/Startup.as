package com.core.view.starling.main
{
//	import away3d.Away3D;
//	import away3d.cameras.Camera3D;
//	import away3d.containers.Scene3D;
//	import away3d.containers.View3D;
//	import away3d.core.managers.Stage3DManager;
//	import away3d.core.managers.Stage3DProxy;
//	import away3d.events.Stage3DEvent;
//	import away3d.loaders.misc.SingleFileLoader;
//	import away3d.loaders.parsers.Parsers;
//	import away3d.loaders.parsers.ParticleGroupParser;
//	import away3d.loaders.parsers.particleSubParsers.LuaEnabler;
    
    import com.core.utils.Statics;
    import com.core.utils.Utils;
    import com.core.utils.composer.ComposerClientController;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import starling.core.Starling;
    import starling.errors.AbstractMethodError;
    import starling.events.Event;

//	import com.assukar.airong.error.AbstractError;
//	import com.assukar.airong.error.AssukarError;
//	import com.assukar.airong.timer.UTimer;
//	import com.assukar.airong.utils.Utils;
//	import com.assukar.airong.utils.composer.ComposerClientController;
//	import com.assukar.domain.main.AssukarContext;
//	import com.assukar.view.starling.FPSCounter;
//	import com.assukar.view.starling.StageSprite;
//	import com.assukar.view.starling.activation.ActivationController;
//	import com.assukar.view.starling.timer.StarlingTimerPlugin;
    
    public class Startup extends Sprite
    {
        
        protected var starling:Starling;
        protected var callback:Function;
        protected var sprite:StarlingSprite;
        protected var started:Boolean = false;
        protected var context3DStarted:Boolean = false;
        
        public function Startup(lateStart:Boolean = false)
        {
            CONFIG::DEBUG
            {
                ComposerClientController.ME = new ComposerClientController();
            }
            
            if (stage && !lateStart) start(stage);
        }
        
        protected function preInitiate():void
        {
            Starling.multitouchEnabled = false;
        }
        
        final public function start(stage:Stage, callback:Function = null):void
        {
            if (started)
            {
                Utils.print(new Error("STARTUP::ALREADYSTARTED"));
                return;
            }
            
            started = true;
            
            this.callback = callback;
            Statics.STAGE = stage;
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_RIGHT;
            
            preInitiate();
            initiate();

//            initProxies();
            initStarling();
            
        }
        
        private function initStarling():void
        {
            
            Utils.print("initStarling");
            
            try
            {
                StarlingSprite.spriteCallback = starlingCallback;
                
                starling = new Starling(StarlingSprite, Statics.STAGE, initialRect); //, stage3DProxy.stage3D, Context3DRenderMode.AUTO, stage3DProxy.profile);
//                starling.shareContext = true;

//                StageSprite.ME.activate(starling);
                
                initiateStarling(starling);
                
            } catch (e:Error)
            {
                Utils.print(e);
            }
            
        }
        
        protected function starlingContext3dCreateListener(e:starling.events.Event):void
        {
            
            Utils.print("starling: starlingContext3dCreateListener");
            
            context3DStarted = true;
//            FPSCounter.ME.notifyContext3DActive();
        
        }
        
        protected function get initialRect():Rectangle
        {
//            return new Rectangle(0, 0, 768, 1024);
            return new Rectangle(0, 0, 800, 600);
        }
        
        protected function initiateStarling(starling:Starling):void
        {
            starling.viewPort = getViewPortRectangle();
        }
        
        protected function adjustStage():void
        {
        }
        
        protected function callbackContext3DCreate(event:flash.events.Event):void
        {
            Utils.print("starling: callbackContext3DCreate");
            
            adjustStage();
            
            starling.start();

//            UTimer.timerFactory = StarlingTimerPlugin;
//            ActivationController.ME.wakeup();
        
        }
        
        protected function starlingCallback(sprite:StarlingSprite):void
        {
            this.sprite = sprite;
            
            starlingContext3dCreateListener(null);
            callbackContext3DCreate(null);
            
            CONFIG::DEBUG
            {
                ComposerClientController.ME.connect(COMPOSER::PORT, COMPOSER::HOST);
            }
            
        }
        
        protected function getViewPortRectangle():Rectangle
        {
            throw new AbstractMethodError();
        }
        
        protected function initiate():void
        {
            throw new AbstractMethodError();
        }
        
        //away3d ///////////////////////////////////////////////////////////////////////////////////////////////

//        // Stage manager and proxy instances
//        protected var stage3DManager:Stage3DManager;
//        protected var stage3DProxy:Stage3DProxy;
//
//        private function initProxies():void
//        {
//            Utils.wraplog("initProxies: " + Utils.stage);
//
//            LuaEnabler.enableLua();
//            SingleFileLoader.enableParser(ParticleGroupParser);
//            Parsers.enableAllBundled();
//
//            stage3DManager = Stage3DManager.getInstance(Utils.stage);
//            stage3DProxy = stage3DManager.getFreeStage3DProxy();
//            stage3DProxy.antiAlias = 0;
//            stage3DProxy.color = 0x0;
//
//            stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, away3DOnContextCreated, false, 0, true);
//
//        }

//        private function away3DOnContextCreated(event:Stage3DEvent):void
//        {
//            Utils.print("away3DOnContextCreated");
//
//            initAway3D();
//            initStarling();
//
//            stage3DProxy.addEventListener(flash.events.Event.ENTER_FRAME, away3DOnRender, false, 0, true);
//        }

//        private function initAway3D():void
//        {
//            Utils.print("initAway3D");
//            initEngine();
//        }

//        protected var away3dView:View3D;
//        protected var away3dScene:Scene3D;
//        protected var away3dCamera:Camera3D;

//        private function initEngine():void
//        {
//            away3dScene = new Scene3D();
//
//            away3dCamera = new Camera3D();
//            away3dCamera.x = 0;
//            away3dCamera.y = 0;
//            away3dCamera.z = -880; // -880
//            away3dCamera.lookAt(new Vector3D());
//
//            away3dView = new View3D();
//            away3dView.stage3DProxy = stage3DProxy;
//            away3dView.shareContext = true;
//            away3dView.scene = away3dScene;
//            away3dView.camera = away3dCamera;
//
//            var vp:Rectangle = getViewPortRectangle();
//            away3dView.x = away3dView.stage3DProxy.x = vp.x;
//            away3dView.y = away3dView.stage3DProxy.y = vp.y;
//            away3dView.width = away3dView.stage3DProxy.width = vp.width;
//            away3dView.height = away3dView.stage3DProxy.height = vp.height;
//
//            addChild(away3dView);
//
//            Away3D.currentView = away3dView;
//        }

//        private function away3DOnRender(e:flash.events.Event):void
//        {
//            if (!starling || (starling.context && starling.context.driverInfo == "Disposed")) return;
//            else
//            {
//                if (starling.isStarted) starling.nextFrame(); else starling.render();
//                if (away3dScene.numChildren) away3dView.render();
//            }
//        }
    
    }
}

