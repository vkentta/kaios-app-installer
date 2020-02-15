# kaios-app-installer

Install [packaged](https://developer.kaiostech.com/getting-started/build-your-first-package-app) or [hosted](https://developer.kaiostech.com/getting-started/build-your-first-hosted-app) KaiOS apps on your KaiOS phone without complex environment setup.

Install Docker, enable debugging mode on your phone and you are ready to install your app.

#### Requirements

* KaiOS phone with Debugging mode enabled (bug icon on task bar of the phone)
    * dialing `*#*#33284#*#*` enables this on some phones
* USB-cable to connect phone to PC
* [Docker installation](https://docs.docker.com/install/)

#### Usage

1. Build your app
2. Navigate into the folder, containing your built app
3. Connect your KaiOS device via USB (make sure USB logo appears on phone task bar)
4. Run ```docker run --rm -v `pwd`:/app-src --device=/dev/bus/usb:/dev/bus/usb vkentta/kaios-app-installer install_packaged```
5. Use the installed app on your phone

In case of hosted app, replace last argument with `install_hosted`.

#### Demo

See `example_app` folder.

#### Thanks

Much of the code is based on https://github.com/jkelol111/make-kaios-install