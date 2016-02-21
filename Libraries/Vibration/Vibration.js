/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule Vibration
 * @flow
 */
'use strict';

var RCTVibration = require('NativeModules').Vibration;

var invariant = require('invariant');

/**
 * The Vibration API is exposed at `Vibration.vibrate()`. On iOS, calling this
 * function will trigger a one second vibration. The vibration is asynchronous
 * so this method will return immediately.
 *
 * There will be no effect on devices that do not support Vibration, eg. the simulator.
 *
 * Note for android
 * add `<uses-permission android:name="android.permission.VIBRATE"/>` to `AndroidManifest.xml`
 *
 * Vibration patterns are currently unsupported.
 */

var Vibration = {
  vibrate: function(duration=400) {
    invariant(
      arguments[0] === undefined,
      'Vibration patterns not supported.'
    );
    RCTVibration.vibrate(duration);
  }
};

module.exports = Vibration;
