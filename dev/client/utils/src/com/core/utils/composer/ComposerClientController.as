package com.core.utils.composer
{
    import com.core.utils.Singleton;
    import com.core.utils.Statics;
    import com.core.utils.Utils;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    public class ComposerClientController
    {
        
        static public var ME:ComposerClientController;
        
        function ComposerClientController()
        {
            registerClassAlias("com.core.utils.composer", ComposerDataObject);
            
            Singleton.enforce(ME);
        }
        
        private var channel:ComposerClientChannel = null;
        
        private function createChannel():ComposerClientChannel
        {
            if (channel) throw Error("channel already created");
            channel = new ComposerClientChannel();
            return channel;
        }
        
        public function connect(localPort:int, localAddress:String):void
        {
            createChannel();
            channel.start(localAddress, localPort);
        }
        
        public function ioErrorHandler(e:IOErrorEvent):void
        {
            Utils.print("ioErrorHandler: " + e.text);
            channel.socket.close();
        }
        
        public function connectedToServer(e:Event):void
        {
            Utils.print("connectedToServer");
        }
        
        public function closeSocket(e:Event):void
        {
            Utils.print("closeSocket");
        }
        
        private var socketDataBytes:ByteArray = new ByteArray();
        
        private const MAX_DECODES_TRIES:uint = 25;
        private var decodesCount:uint = 0;
        
        public function socketData(e:ProgressEvent):void
        {
            socketDataBytes.position = 0;
            channel.socket.readBytes(socketDataBytes, socketDataBytes.bytesAvailable, channel.socket.bytesAvailable);
            
            var temp:ByteArray = new ByteArray();
            temp.writeObject(socketDataBytes);
            
            var result:ComposerDataObject;
            try
            {
                temp.position = 0;
                var resultTemp:ByteArray = temp.readObject() as ByteArray;
                resultTemp.position = 0;
                result = resultTemp.readObject() as ComposerDataObject;
            } catch (err:Error)
            {
                Utils.print("trying do decode data...");
                if (++decodesCount <= MAX_DECODES_TRIES) return;
            }

//            Utils.print("decode completed " + result);
//            Utils.print("decode completed");
            socketDataBytes.clear();
            
            processData(result);
            decodesCount = 0;
            
        }
        
        private function processData(result:ComposerDataObject):void
        {
            switch (result.action)
            {
            case ComposerDataAction.REFRESH:
                composerRefresh(result.data as Array);
                break;
            case ComposerDataAction.SELECT_COMP:
                composerSelectComp(result.data as String);
                break;
            case ComposerDataAction.UPDATE_PROP_LABEL:
                composerUpdatePropLabel(result.data as String);
                break;
            case ComposerDataAction.GET_PROP_LABEL:
                composerGetPropLabel(result.data as Array);
                break;
            case ComposerDataAction.COPY_PROP:
                composerCopyProp(result.data as Array);
                break;
            case ComposerDataAction.CHANGE_PROP:
                composerChangeProp(result.data as Array);
                break;
            case ComposerDataAction.APPLY_PROP:
                composerApplyProp(result.data as Array);
                break;
            case ComposerDataAction.PAUSE_TOGGLE:
                composerPauseToggle(result.data as Boolean);
                break;
            case ComposerDataAction.DRAW:
                composerDraw();
                break;
            }
            
        }
        
        // composer refresh //////
        
        private function composerRefresh(result:Array):void
        {
            clearLayer();
            
            var clazz:Object = Statics.APPLICATION_DOMAIN.getDefinition(result[0]);
            var methods:String = result[1];
            if (methods && methods.length)
            {
                var methodsTemp:Array = methods.split(",");
                while (methodsTemp.length) clazz = clazz[methodsTemp.shift()];
            }
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.REFRESH;
            cdo.data = parseComp(clazz, null) as XML;
            reply(cdo);
        }
        
        private var childList:Dictionary = new Dictionary();
        
        private function parseComp(dob:Object, result:XML = null):XML
        {
            var namee:String;
            var className:String = getClassName(dob);
            namee = (dob.name ? dob.name : className != "null" ? className : String(dob)) + "." + String(int.MAX_VALUE * Math.random()).split(".")[0];
            
            childList[namee] = dob;
            
            if (!result) result = <data></data>;
            var nodeTemp:XML = <node></node>;
            nodeTemp.@name = namee;
            result = result.appendChild(nodeTemp);
            
            if (dob.hasOwnProperty("numChildren"))
            {
                var i:int, len:int = dob.numChildren;
                for (i = 0; i < len; i++) parseComp(dob.getChildAt(i), nodeTemp);
            }
            
            return result;
        }
        
        private function getClassName(o:*):String
        {
            if (o == null) return "null";
            try
            {
                return String(Class(Statics.APPLICATION_DOMAIN.getDefinition(getQualifiedClassName(o)))).replace("class ", "");
            } catch (err:Error)
            {
                Utils.print(err.message);
            }
            return "null";
        }
        
        //////////
        
        // composer select comp ////////
        private var dob:Object;
        
        private function composerSelectComp(result:String):void
        {
            dob = childList[result];
            if (dob.hasOwnProperty("unflatten")) dob["unflatten"]();
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.SELECT_COMP;
            
            cdo.data = parseProps().toXMLString();
            reply(cdo);
        }
        
        private function parseProps():XMLList
        {
            return describeType(dob).elements().( //
                    (//
                    name() == "accessor" && ( //
                            //
                            // native
                            @declaredBy == "flash.text::TextField"  //
                            || @declaredBy == "flash.text::StageText"  //
                            || @declaredBy == "flash.display::DisplayObject"  //
                            //
                            // starling
                            || @declaredBy == "starling.display::DisplayObject"  //
                            || @declaredBy == "starling.display::DisplayObjectContainer" //
                            || @declaredBy == "starling.display::Quad" //
                            || @declaredBy == "starling.display::Image" //
                            || @declaredBy == "starling.display::Sprite" //
                            || @declaredBy == "starling.display::Sprite3D" //
                            || @declaredBy == "starling.text::TextField" //
                            || @declaredBy == "starling.extensions::ParticleSystem" //
                            || @declaredBy == "starling.extensions::PDParticleSystem" //
                            //
                            // custom
                            || @declaredBy == "com.assukar.view.starling::Component" //
                            || @declaredBy == "com.assukar.view.starling::EffectableComponent" //
                            || @declaredBy == "com.assukar.view.starling::AssukarTextField" //
                            || @declaredBy == "com.assukar.view.starling::AssukarMovieClip" //
                            || @declaredBy == "com.assukar.view.starling::AssukarMovieBytes" //
                    ) //
                    && @access == "readwrite") // || name() == "variable" //
                    ).( //
            @type == "uint" //
            || @type == "int" //
            || @type == "Number" //
            || @type == "Boolean" //
            || @type == "String" //
                    ).(@name != "name"); //
            //
        }
        
        private function composerUpdatePropLabel(result:String):void
        {
            var list:XMLList = new XMLList(result);
            var tempNodeName:String;
            for each (var node:XML in list)
            {
                tempNodeName = String(node.@name).split(":")[0];
                if (tempNodeName == "color") node.@name = tempNodeName + ": 0x" + uint(dob[tempNodeName]).toString(16);
                else node.@name = tempNodeName + ": " + fixPropName(String(dob[tempNodeName]));
                delete node.metadata;
            }
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.UPDATE_PROP_LABEL;
            cdo.data = list.toXMLString();
            reply(cdo);
        }
        
        private function fixPropName(value:String):String
        {
            if (!value) return "null";
            value = value.replace(/[\u000d\u000a\u0008\u0020]+/g, " ");
            return value.length >= 30 ? value.slice(0, 30) + "..." : value;
        }
        
        private function composerCopyProp(result:Array):void
        {
            var temp:Array;
            var toSend:String = "{";
            var value:String;
            var valueTemp:*;
            var flag:Boolean = false;
            for each (var item:XML in result)
            {
                if (flag) toSend += ", ";
                temp = item.@name.split(": ");
                valueTemp = dob[temp[0]];
                value = valueTemp is String ? JSON.stringify(valueTemp) : String(valueTemp);
                toSend += temp[0] + ": " + value;
                flag = true;
            }
            toSend += "}";
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.COPY_PROP;
            cdo.data = toSend;
            reply(cdo);
            
        }
        
        private function composerGetPropLabel(result:Array):void
        {
            var toSend:Array = [];
            for (var i:int = 0; i < result.length; i++)
            {
                var nodeName:String = String(result[i].@name).split(":")[0];
                toSend[i] = nodeName + ":    " + result[i].@type + "\nvalue:    " + (nodeName == "color" ? "0x" + uint(dob[nodeName]).toString(16) : fixPropName(dob[nodeName]));
            }
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.GET_PROP_LABEL;
            cdo.data = toSend;
            reply(cdo);
            
        }
        
        private function composerChangeProp(result:Array):void
        {
            var toSend:Array = [];
            for (var i:int = 0; i < result.length; i++)
            {
                if (result[i] && dob)
                {
                    var nodeName:String = String(result[i].@name).split(":")[0];
                    toSend[i] = dob[nodeName];
                }
            }
            
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.CHANGE_PROP;
            cdo.data = toSend as Array;
            reply(cdo);
        }
        
        private function composerApplyProp(result:Array):void
        {
            // send
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.APPLY_PROP;
            try
            {
                dob[String(result[0])] = result[1];
                cdo.data = true;
            } catch (err:Error)
            {
                Utils.print(err.message);
                cdo.data = false;
            }
            reply(cdo);
        }
        
        static private const DEFAULT_DEFINITION:String = "starling.core::Starling";
        private var starlingg:Object = null;
        
        private function composerPauseToggle(result:Boolean):void
        {
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.PAUSE_TOGGLE;
            cdo.data = null;
            
            try
            {
                starlingg = Statics.APPLICATION_DOMAIN.getDefinition(DEFAULT_DEFINITION)["current"];
                starlingg[String(result ? "stop" : "start")]();
            } catch (e:Error)
            {
                cdo.data = e.message as String;
            }
            
            reply(cdo);
        }
        
        private var layer:Object = null;
        
        private function clearLayer():void
        {
            try
            {
                if (!starlingg) starlingg = Statics.APPLICATION_DOMAIN.getDefinition(DEFAULT_DEFINITION)["current"];
                if (layer)
                {
                    layer["removeChildren"](0, -1, true);
                    layer["dispose"]();
                    if (starlingg["stage"]["contains"](layer)) starlingg["stage"]["removeChild"](layer);
                }
            } catch (e:Error)
            {
                Utils.print(e.message);
            }
        }
        
        private function composerDraw():void
        {
            
            var cdo:ComposerDataObject = new ComposerDataObject();
            cdo.action = ComposerDataAction.DRAW;
            cdo.data = null;
            
            try
            {
                clearLayer();
                
                var spriteClazz:Object = Statics.APPLICATION_DOMAIN.getDefinition("starling.display::Sprite");
                layer = new spriteClazz();
                layer["name"] = "INDIVIDUAL_LAYER";
                
                var quadClazz:Object = Statics.APPLICATION_DOMAIN.getDefinition("starling.display::Quad");
                var layerBg:Object = new quadClazz(Statics.VIEW_PORT.width, Statics.VIEW_PORT.height, 0xe1e1e1);
                layerBg["alpha"] = 0.95;
                layer["addChild"](layerBg);
                layer["touchable"] = true;
                
                starlingg["stage"]["addChild"](layer);
                
                var clazz:Object = Statics.APPLICATION_DOMAIN.getDefinition(getQualifiedClassName(dob));
                layer["addChild"]((new clazz())["draw"]());
                
                cdo.data = parseComp(layer["getChildAt"](1), null).toXMLString();
                
            } catch (e:Error)
            {
                Utils.print(e.message);
                clearLayer();
            }
            
            reply(cdo);
        }
        
        ///////////////////////////////
        
        public function reply(data:ComposerDataObject):void
        {
            try
            {
                if (channel.socket != null && channel.socket.connected)
                {
                    channel.socket.writeObject(data);
                    channel.socket.flush();

//                    Utils.print("Sent message");
                }
                else Utils.print("No socket connection");
            } catch (err:Error)
            {
                Utils.print(err.message);
            }
        }
        
    }
}
