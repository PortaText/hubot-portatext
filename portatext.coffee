# Description:
#  Simple PortaText Integration
#
# Dependencies:
#   "portatext": "1.0.9"
#
# Configuration:
#   HUBOT_PORTATEXT_APIKEY
#   HUBOT_PORTATEXT_FROM
#
# Commands:
#   hubot sms_group list - Returns a list of your contact lists
#   hubot sms_group create <name> <description> - Creates a new contact list
#   hubot sms_group delete <name> - Deletes a new contact list
#   hubot sms_group add <number> to <list name> - Adds a phone number to a contact list
#   hubot sms_group remove <number> from <list name> - Removes phone number from a contact list
#   hubot sms_group send to <list name> <message> - Sends a message to a contact list
#   hubot sms_contact add <name> <number> - Adds the contact named "name" with the phone number "number"
#   hubot sms <name> <message> - Sends the given message to the given stored phone number of the contacta named "name"

main = (apiKey, from) ->
  portatextMod = require 'portatext';
  util = require 'util';
  portatext = new portatextMod.ClientHttp
  portatext.setApiKey apiKey

  return (robot) ->
    robot.respond /sms_group list/i, (res) ->
      result = portatext.
        contactLists().
        get().
        then((result) ->
          lists = (list.name for list in result.data.contact_lists)
          res.reply "These are the contact lists that I know of: #{util.inspect(lists)}"
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't get your contact lists, sorry: #{util.inspect err}"
        )

    robot.respond /sms_group create ([^ ]*) (.*)/i, (res) ->
      name = res.match[1]
      description = res.match[2]
      result = portatext.
        contactLists().
        name(name).
        description(description).
        post().
        then((result) ->
          res.reply "Your contact list has been created!"
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't create the contact list, sorry: #{util.inspect err}"
        )

    robot.respond /sms_group delete ([^ ]*)/i, (res) ->
      name = res.match[1]
      result = portatext.
        contactLists().
        get().
        then((result) ->
          lists = result.data.contact_lists.filter (c) -> c.name == name
          if lists.length != 1
            res.reply "I couldn't find the contact list #{name}"
          else
            portatext.
              contactLists().
              id(lists[0].id).
              delete().
              then((result) ->
                res.reply "Your contact list has been deleted!"
              ).
              catch((err) ->
                robot.emit 'error', err
                res.reply "I couldn't delete the contact list, sorry: #{util.inspect err}"
              )
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't get your contact lists, sorry: #{util.inspect err}"
        )

    robot.respond /sms_group add ([^ ]*) to ([^ ]*)/i, (res) ->
      number = res.match[1]
      name = res.match[2]
      result = portatext.
        contactLists().
        get().
        then((result) ->
          lists = result.data.contact_lists.filter (c) -> c.name == name
          if lists.length != 1
            res.reply "I couldn't find the contact list #{name}"
          else
            portatext.
              contactLists().
              id(lists[0].id).
              withNumber(number).
              put().
              then((result) ->
                res.reply "#{number} has been added to #{name}"
              ).
              catch((err) ->
                robot.emit 'error', err
                res.reply "I couldn't add #{number} to the contact list, sorry: #{util.inspect err}"
              )
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't get your contact lists, sorry: #{util.inspect err}"
        )

    robot.respond /sms_group remove ([^ ]*) from ([^ ]*)/i, (res) ->
      number = res.match[1]
      name = res.match[2]
      result = portatext.
        contactLists().
        get().
        then((result) ->
          lists = result.data.contact_lists.filter (c) -> c.name == name
          if lists.length != 1
            res.reply "I couldn't find the contact list #{name}"
          else
            portatext.
              contactLists().
              id(lists[0].id).
              withNumber(number).
              delete().
              then((result) ->
                res.reply "#{number} has been removed from #{name}"
              ).
              catch((err) ->
                robot.emit 'error', err
                res.reply "I couldn't remove #{number} from the contact list, sorry: #{util.inspect err}"
              )
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't get your contact lists, sorry: #{util.inspect err}"
        )

    robot.respond /sms_group send to ([^ ]*) (.*)/i, (res) ->
      message = res.match[2]
      name = res.match[1]
      result = portatext.
        contactLists().
        get().
        then((result) ->
          lists = result.data.contact_lists.filter (c) -> c.name == name
          if lists.length != 1
            res.reply "I couldn't find the contact list #{name}"
          else
            portatext.
              sms().
              toContactLists([lists[0].id]).
              from(from).
              text(message).
              post().
              then((result) ->
                res.reply "I sent your message to the group #{name}"
              ).
              catch((err) ->
                robot.emit 'error', err
                res.reply "I couldn't send your message to #{name}, sorry: #{util.inspect err}"
              )
        ).
        catch((err) ->
          robot.emit 'error', err
          res.reply "I couldn't get your contact lists, sorry: #{util.inspect err}"
        )

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

