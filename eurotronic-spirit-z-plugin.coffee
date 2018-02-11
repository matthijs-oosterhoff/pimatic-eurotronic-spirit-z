module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'

  class EurotronicSpiritPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      env.logger.info('Eurotronic Spirit initializing')
      env.logger.info("zwave-usb installed:", @framework.pluginManager.isInstalled("pimatic-zwave-usb"));
      @zwavePlugin = @framework.pluginManager.getPlugin("zwave-usb");
      @protocolHandler = @zwavePlugin.protocolHandler

      deviceConfigDef = require('./device-config-schema')
      className = 'EurotronicSpiritZ';
      classType = require('./device')(env)

      env.logger.debug('Registering device')
      @framework.deviceManager.registerDeviceClass(className, {
        configDef: deviceConfigDef,
        createCallback: @zwavePlugin._callbackHandler(className, classType)
      })


  return new EurotronicSpiritPlugin