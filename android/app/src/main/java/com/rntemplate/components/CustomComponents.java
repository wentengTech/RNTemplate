package com.rntemplate.components;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.rntemplate.components.image.imageView.YDImageViewManager;

import java.util.Arrays;
import java.util.List;

/**
 * Created by jgfidelis on 02/02/18.
 */

public class CustomComponents implements ReactPackage {


    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactApplicationContext) {
        return Arrays.asList(
        );
    }


    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactApplicationContext) {
        return Arrays.asList(
                new YDImageViewManager(reactApplicationContext)
        );
    }
}
