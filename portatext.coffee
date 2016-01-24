# Description:
#  Simple PortaText Integration
#
# Dependencies:
#   "portatext": "1.0.7"
#
# Configuration:
#   HUBOT_PORTATEXT_APIKEY
#   HUBOT_PORTATEXT_FROM
#
# Commands:
#   hubot sms_contact add <name> <number> - Adds the contact named "name" with the phone number "number"
#   hubot sms <name> <message> - Sends the given message to the given stored phone number of the contacta named "name"

main = (apiKey, from) ->
  portatextMod = require 'portatext';
  util = require 'util';
  portatext = new portatextMod.ClientHttp
  portatext.setApiKey apiKey

  return (robot) ->
    robot.respond /sms_contact add ([^ ]*) (.*)/i, (res) ->
      robot.brain.set res.match[1], res.match[2]
      res.reply "I'll remember that #{res.match[1]} can be reached at #{res.match[2]}"

    robot.respond /sms ([^ ]*) (.*)/i, (res) ->
      name = res.match[1]
      number = robot.brain.get name
      if number?
        portatext.
          sms().
          from(from).
          to(number).
          text(res.match[2]).
          post().
          then((result) ->
            res.reply "Ok, I sent your message to #{name} to the phone number #{number}"
          ).
          catch((err) ->
            robot.emit 'error', err
            res.reply "I'm sorry I couldn't sent that! #{util.inspect err}"
          )
      else
        resreply "Sorry, I don't know any phone numbers to reach #{name}"

module.exports = main(process.env.HUBOT_PORTATEXT_APIKEY, process.env.HUBOT_PORTATEXT_FROM);
