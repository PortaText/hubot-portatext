# hubot-portatext

Hubot integration with PortaText.

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