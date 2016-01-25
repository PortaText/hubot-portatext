[![License](http://img.shields.io/badge/license-APACHE2-blue.svg)](http://img.shields.io/badge/license-APACHE2-blue.svg)

# hubot-portatext

[Hubot](https://github.com/github/hubot) integration with [PortaText](https://www.portatext.com/).

Easily send SMS messages from your hubot :)

## Installation
 * Grab the [portatext.coffee](https://github.com/PortaText/hubot-portatext/blob/master/portatext.coffee) file and drop it
in the `scripts` directory of your hubot.
 * Add the portatext dependency to the `package.json` file in the root directory of your hubot:

 ```json
 "dependencies": {
    ...
    "portatext": "1.0.7"
 }
 ```

 * Add the following environment variables when starting hubot:
  * HUBOT_PORTATEXT_APIKEY (your portatext api key).
  * HUBOT_PORTATEXT_FROM (DID to be used as the source phone number of your messages).

 * Restart hubot.

## Commands

### Add a contact name and number
```
  hubot sms_contact add john 12223334444
```

### Send a message to a known contact name
```
  hubot sms john Hey dude, make sure you bring enough coffe -- script!
```

# License
The source code is released under Apache 2 License.

Check [LICENSE](https://github.com/PortaText/node-sdk/blob/master/LICENSE) file for more information.
