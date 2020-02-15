/**
 * Load this script in xpcshell and connect...
 */

Components.utils.import("resource://gre/modules/devtools/dbg-client.jsm");

var gQuit = false;

try {
  dump("Connecting to install " + arguments[0] + "\n");
  const appId = arguments[0];
  const port = arguments[1];

  connectAndInstallApp(port, appId)
} catch (ex) {
  dump("Couldn't connect: " + ex + "\n");
  quit(1);
}

var mainThread = Components.classes[
  "@mozilla.org/thread-manager;1"
].getService().mainThread;

while (!gQuit) {
  mainThread.processNextEvent(true);
}

function connectAndInstallApp(port, appId) {
  const gClient = new DebuggerClient(connect(port));

  gClient.connect(function onConnected(aType, aTraits) {
    dump("Connected, searching webappsActor ...\n");
    gClient.listTabs(function(aResponse) {
      if (!aResponse.webappsActor) {
        dump("No webapps remote actor!\n");
        quit();
        return;
      }
      gClient.addListener("webappsEvent", onWebappsEvent);
      gClient.request(
        { to: aResponse.webappsActor, type: "install", appId: appId, appType: 2 },
        onInstallResponse
      );
    });
  });
}

function connect(port) {
  gTransport = debuggerSocketConnect("localhost", port);
  gTransport.hooks = {
    onClosed: function() {
      print("Connection closed, quitting.");
      quit();
    }
  };
  gTransport.ready();

  return gTransport;
}

function onWebappsEvent(aState, aType, aPacket) {
  dump("Error: " + aType.message + "\n");
  quit();
}

function onInstallResponse(aResponse) {
  if (aResponse.error) {
    dump("Failed to install: " + aResponse.message + "\n");
    quit();
  } else {
    dump("Succesfully installed!\n");
    quit();
  }
}

function quit() {
  gQuit = true;
}