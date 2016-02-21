package com.facebook.react.modules.vibration;

import android.content.Context;
import android.os.Vibrator;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class VibrationModule extends ReactContextBaseJavaModule {
    ReactApplicationContext reactContext;

    public VibrationModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Vibration";
    }

    @ReactMethod
    public void vibrate(int duration) {
        Vibrator v = (Vibrator) reactContext.getSystemService(Context.VIBRATOR_SERVICE);
        v.vibrate(duration);
    }
}
