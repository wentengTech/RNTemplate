package com.rntemplate;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;

import org.devio.rn.splashscreen.SplashScreenReactPackage;

import com.learnium.RNDeviceInfo.RNDeviceInfo;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.soloader.SoLoader;
import com.rntemplate.components.CustomComponents;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

public class MainApplication extends Application implements ReactApplication, Application.ActivityLifecycleCallbacks {

    private static Context context;
    private static volatile Activity mCurrentActivity;
    private static Boolean deviceIsInFront = false;


    public static Context getCurrentContext() {
        return MainApplication.context;
    }

    public static synchronized Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public static synchronized void setCurrentActivity(Activity activity) {
        mCurrentActivity = activity;
    }

    public static Boolean getDeviceIsInFront() {
        return deviceIsInFront;
    }

    public static void setDeviceIsInFront(Boolean deviceIsInFront) {
        MainApplication.deviceIsInFront = deviceIsInFront;
    }

    //
    //
    //

    private final ReactNativeHost mReactNativeHost =
            new ReactNativeHost(this) {
                @Override
                public boolean getUseDeveloperSupport() {
                    return BuildConfig.DEBUG;
                }

                @Override
                protected List<ReactPackage> getPackages() {
                    @SuppressWarnings("UnnecessaryLocalVariable")
                    List<ReactPackage> packages = new PackageList(this).getPackages();
                    // Packages that cannot be autolinked yet can be added manually here, for example:

                    // customer getPackages
                    packages.add(new CustomComponents());

                    return packages;
                }

                @Override
                protected String getJSMainModuleName() {
                    return "index";
                }
            };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        MainApplication.context = getApplicationContext();

        SoLoader.init(this, /* native exopackage */ false);
        initializeFlipper(this, getReactNativeHost().getReactInstanceManager());
    }

    /**
     * Loads Flipper in React Native templates. Call this in the onCreate method with something like
     * initializeFlipper(this, getReactNativeHost().getReactInstanceManager());
     *
     * @param context
     * @param reactInstanceManager
     */
    private static void initializeFlipper(
            Context context, ReactInstanceManager reactInstanceManager) {
        if (BuildConfig.DEBUG) {
            try {
        /*
         We use reflection here to pick up the class that initializes Flipper,
        since Flipper library is not available in release mode
        */
                Class<?> aClass = Class.forName("com.rntemplate.ReactNativeFlipper");
                aClass
                        .getMethod("initializeFlipper", Context.class, ReactInstanceManager.class)
                        .invoke(null, context, reactInstanceManager);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
    }


    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    public static int activityCount = 0;//activity的count数

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {
        MainApplication.activityCount++;
    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
        MainApplication.setCurrentActivity(activity);
        isForeground();
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
        MainApplication.setCurrentActivity(null);
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
        MainApplication.activityCount--;
        isForeground();
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {

    }

    private void isForeground() {
        if (activityCount > 0) {
            MainApplication.setDeviceIsInFront(true);
        } else {
            MainApplication.setDeviceIsInFront(false);
        }
    }
    //

}
