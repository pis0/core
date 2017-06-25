package com.core.utils.composer
{
    import com.core.utils.Utils;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    
    public class ComposerClientChannel
    {
        
        function ComposerClientChannel()
        {
        }
        
        private var clientSocket:Socket;
        
        public function start(host:String, port:int):void
        {
            clientSocket = new Socket();
            clientSocket.addEventListener(Event.CONNECT, ComposerClientController.ME.connectedToServer);
            clientSocket.addEventListener(ProgressEvent.SOCKET_DATA, ComposerClientController.ME.socketData);
            clientSocket.addEventListener(IOErrorEvent.IO_ERROR, ComposerClientController.ME.ioErrorHandler);
            clientSocket.addEventListener(Event.CLOSE, ComposerClientController.ME.closeSocket);
            
            clientSocket.connect(host, port);
            
            Utils.print("Connecting to " + host + ":" + port);
        }
        
        public function get socket():Socket
        {
            return clientSocket;
        }
        
        
    }
}
