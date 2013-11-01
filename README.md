CoffeeKiosk
===========

A coffee kiosk accounting application. The perfect solution for your office where you don't have a vendor machine and have to manage your own office coffee piggy bank. This solution offers you a MongoDB/node.js powered API, an iPad app and Graphite publishing agent to make this part of your office life easy and fun.<br/>
The backend exposes RESTful-like JSON API for retreiving users and posting "cup" events, which will descrease the user's balance.<br/><br/>
The default cost of a cup is 0.15 EUR (you can change it in the `server.js`). The detailed API description you can find just looking into the source code of the `server.js`.<br/>

Requirements
-----------

 - Node.js (v0.10+)
 - CocoaPods (0.27+)


Installation
-----------

Installing and running the server:

    $ cd Server
    $ npm install .
    $ node server.js
  
The application will be available by default at [http://localhost:9999/](http://localhost:9999/admin/).<br/>
The admin interface at [http://localhost:9999/admin/](http://localhost:9999/admin/).

Installing and running the iPad application:

    $ cd iPad
    $ pod install
    $ open KaffeeKiosk.xcworkspace

Running Example
-----------

Example of the admin panel to manage users and their balances.

![Admin UI](https://raw.github.com/U-Boot-Sidekicks/CoffeeKiosk/master/Screenshots/Image2.png)

This example shows the app running on the old iPad 1 (iOS 6.1) in the custom case locked to a table with standard Kensington lock.

![Hardware Setup](https://raw.github.com/U-Boot-Sidekicks/CoffeeKiosk/master/Screenshots/Image1.png)



