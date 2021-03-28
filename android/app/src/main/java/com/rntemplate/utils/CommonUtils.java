package com.rntemplate.utils;

import android.app.Application;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.PointF;
import android.net.Uri;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import com.rntemplate.MainApplication;
import com.rntemplate.R;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Hashtable;

import es.dmoral.toasty.Toasty;

//import cc.cloudist.acplibrary.ACProgressConstant;
//import cc.cloudist.acplibrary.ACProgressFlower;

public enum CommonUtils {

    shared;

    public int dpToPx(int dp) {
        if (dp == 0) {
            return 0;
        }
        DisplayMetrics displayMetrics = MainApplication.getCurrentContext().getResources().getDisplayMetrics();
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    public int dpToPx(Context context, int dp) {
        if (dp == 0) {
            return 0;
        }
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT));
    }


    public static boolean deviceHasNavigationBar() {
        boolean haveNav = false;
        try {
            //1.通过WindowManagerGlobal获取windowManagerService
            // 反射方法：IWindowManager windowManagerService = WindowManagerGlobal.getWindowManagerService();
            Class<?> windowManagerGlobalClass = Class.forName("android.view.WindowManagerGlobal");
            Method getWmServiceMethod = windowManagerGlobalClass.getDeclaredMethod("getWindowManagerService");
            getWmServiceMethod.setAccessible(true);
            //getWindowManagerService是静态方法，所以invoke null
            Object iWindowManager = getWmServiceMethod.invoke(null);

            //2.获取windowMangerService的hasNavigationBar方法返回值
            // 反射方法：haveNav = windowManagerService.hasNavigationBar();
            Class<?> iWindowManagerClass = iWindowManager.getClass();
            Method hasNavBarMethod = iWindowManagerClass.getDeclaredMethod("hasNavigationBar");
            hasNavBarMethod.setAccessible(true);
            haveNav = (Boolean) hasNavBarMethod.invoke(iWindowManager);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return haveNav;
    }


    private volatile static boolean mHasCheckAllScreen;
    private volatile static boolean mIsAllScreenDevice;

    public static boolean isAllScreenDevice(Context context) {
        if (mHasCheckAllScreen) {
            return mIsAllScreenDevice;
        }
        mHasCheckAllScreen = true;
        mIsAllScreenDevice = false;
        // 低于 API 21的，都不会是全面屏。。。
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return false;
        }
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        if (windowManager != null) {
            Display display = windowManager.getDefaultDisplay();
            Point point = new Point();
            display.getRealSize(point);
            float width, height;
            if (point.x < point.y) {
                width = point.x;
                height = point.y;
            } else {
                width = point.y;
                height = point.x;
            }
            if (height / width >= 1.97f) {
                mIsAllScreenDevice = true;
            }
        }
        return mIsAllScreenDevice;
    }


    /**
     * 生成显示编码的Bitmap
     *
     * @param contents
     * @param width
     * @param height
     * @param context
     * @return
     */
    protected Bitmap creatCodeBitmap(String contents, int width,
                                     int height, Context context) {
        TextView tv = new TextView(context);
        ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        tv.setLayoutParams(layoutParams);
        tv.setText(contents);
        tv.setHeight(height);
        tv.setGravity(Gravity.CENTER_HORIZONTAL);
        tv.setWidth(width);
        tv.setDrawingCacheEnabled(true);
        tv.setTextColor(Color.BLACK);
        tv.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
        tv.layout(0, 0, tv.getMeasuredWidth(), tv.getMeasuredHeight());

        tv.buildDrawingCache();
        Bitmap bitmapCode = tv.getDrawingCache();
        return bitmapCode;
    }

    /**
     * 将两个Bitmap合并成一个
     *
     * @param first
     * @param second
     * @param fromPoint 第二个Bitmap开始绘制的起始位置（相对于第一个Bitmap）
     * @return
     */
    protected Bitmap mixtureBitmap(Bitmap first, Bitmap second, PointF fromPoint) {
        if (first == null || second == null || fromPoint == null) {
            return null;
        }
        int marginW = 20;
        Bitmap newBitmap = Bitmap.createBitmap(
                first.getWidth() + second.getWidth() + marginW,
                first.getHeight() + second.getHeight(), Bitmap.Config.ARGB_4444);
        Canvas cv = new Canvas(newBitmap);
        cv.drawBitmap(first, marginW, 0, null);
        cv.drawBitmap(second, fromPoint.x, fromPoint.y, null);
        cv.save();
        cv.restore();

        return newBitmap;
    }

    public void showSuccess(String title) {
        Toasty.custom(MainApplication.getCurrentContext(), title, MainApplication.getCurrentContext().getDrawable(R.drawable.ic_check_white_24dp), Color.parseColor("#FCD828"), Color.BLACK, Toast.LENGTH_SHORT, true, true).show();
    }

    public void showFailure(String title) {
        Toasty.error(MainApplication.getCurrentContext(), title, Toast.LENGTH_SHORT, true).show();
    }


    public void show(String content) {
        Toasty.normal(MainApplication.getCurrentContext(), content).show();
    }


    /**
     * 调用第三方浏览器打开
     *
     * @param context
     * @param url     要浏览的资源地址
     */
    public void openBrowser(Context context, String url) {
        final Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(url));
        // 注意此处的判断intent.resolveActivity()可以返回显示该Intent的Activity对应的组件名
        // 官方解释 : Name of the component implementing an activity that can display the intent
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            final ComponentName componentName = intent.resolveActivity(context.getPackageManager()); // 打印Log   ComponentName到底是什么 L.d("componentName = " + componentName.getClassName());
            context.startActivity(Intent.createChooser(intent, "请选择浏览器"));
        } else {
            Toast.makeText(context.getApplicationContext(), "请下载浏览器", Toast.LENGTH_SHORT).show();
        }
    }


    public static String getFileName(String filePath) {
        if (StringUtils.singleton.isEmpty(filePath)) {
            return null;
        }
        return filePath.substring(filePath.lastIndexOf("/") + 1) + CryptoUtils.singleton.encodeBASE64(filePath);
    }

    public static String getPath(Context context, Uri uri) {
        if ("content".equalsIgnoreCase(uri.getScheme())) {
            String[] projection = {"_data"};
            Cursor cursor = null;
            try {
                cursor = context.getContentResolver().query(uri, projection, null, null, null);
                int column_index = cursor.getColumnIndexOrThrow("_data");
                if (cursor.moveToFirst()) {
                    return cursor.getString(column_index);
                }
            } catch (Exception e) {
                // Eat it  Or Log it.
            }
        } else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }
        return null;
    }

    public Double getDouble(JSONObject jsonObject, String key) {
        if (jsonObject == null || StringUtils.singleton.isEmpty(key)) {
            return null;
        }
        try {
            return jsonObject.getDouble(key);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getInteger(JSONObject jsonObject, String key) {
        if (jsonObject == null || StringUtils.singleton.isEmpty(key)) {
            return null;
        }
        try {
            return jsonObject.getInt(key);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getString(JSONObject jsonObject, String key) {
        if (jsonObject == null || StringUtils.singleton.isEmpty(key)) {
            return null;
        }
        if (!jsonObject.has(key)) {
            return null;
        }
        try {
            return jsonObject.getString(key);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Boolean getBoolean(JSONObject jsonObject, String key) {
        if (jsonObject == null || StringUtils.singleton.isEmpty(key)) {
            return null;
        }
        try {
            return jsonObject.getBoolean(key);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public JSONObject getJsonObject(JSONObject jsonObject, String key) {
        if (jsonObject == null || StringUtils.singleton.isEmpty(key)) {
            return null;
        }
        try {
            return jsonObject.getJSONObject(key);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public boolean isDeleteStatus(String deleteStatus) {
        if (StringUtils.singleton.isEmpty(deleteStatus)) {
            return false;
        }
        return deleteStatus.equals("deleted");
    }


    //

    public String getDateTypeStr(String dateType) {
        if (StringUtils.singleton.isEmpty(dateType)) {
            return null;
        }
        if (dateType.equals("today")) {
            return "今日";
        } else if (dateType.equals("yesterday")) {
            return "昨日";
        } else if (dateType.equals("lastWeek")) {
            return "上周";
        } else if (dateType.equals("currentWeek")) {
            return "本周";
        } else if (dateType.equals("currentMonth")) {
            return "本月";
        }

        return null;
    }


    public Double precision(Double value) {
        if (value == null) {
            return 0.0;
        }
        try {
            String valueStr = String.format("%.2f", value);
            return Double.valueOf(valueStr);
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    public Integer getPriceValue(String priceRMBStr) {
        return getPriceValue(priceRMBStr, 100);
    }

    public Integer getPriceValue(String priceRMBStr, Integer changeRate) {
        if (StringUtils.singleton.isEmpty(priceRMBStr)) {
            return null;
        }
        if (priceRMBStr.contains("¥")) {
            priceRMBStr = priceRMBStr.replaceAll("¥", "");
        }
        if (StringUtils.singleton.isEmpty(priceRMBStr)) {
            return null;
        }
        try {
            Double priceRMB = Double.valueOf(priceRMBStr);
            double price = priceRMB * changeRate;
            return (int) price;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getPriceText(Double price) {
        if (price == null) {
            return "¥ -";
        } else {
            return "¥ " + price;
        }
    }

    public String getNumberText(Number value) {
        if (value == null) {
            return "";
        } else {
            return value.toString();
        }
    }

    public String getNumberText(Number value, String defaultContent) {
        String numberText = getNumberText(value);
        if (StringUtils.singleton.isEmpty(numberText)) {
            return defaultContent;
        }
        return numberText;
    }


    public int getVersionCode(Context mContext) {
        int versionCode = 0;
        try {
            //获取软件版本号，对应AndroidManifest.xml下android:versionCode
            versionCode = mContext.getPackageManager().
                    getPackageInfo(mContext.getPackageName(), 0).versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionCode;
    }

    /**
     * 获取版本号名称
     *
     * @param context 上下文
     * @return
     */
    public String getVerName(Context context) {
        String verName = "";
        try {
            verName = context.getPackageManager().
                    getPackageInfo(context.getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return verName;
    }


    public Bitmap getFitSampleBitmap(InputStream inputStream) throws Exception {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        byte[] bytes = readStream(inputStream);
        BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
        options.inSampleSize = 2;
        options.inJustDecodeBounds = false;
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
    }

    /**
     * 从inputStream中获取字节流 数组大小
     **/
    private byte[] readStream(InputStream inStream) throws Exception {
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int len = 0;
        while ((len = inStream.read(buffer)) != -1) {
            outStream.write(buffer, 0, len);
        }
        outStream.close();
        inStream.close();
        return outStream.toByteArray();
    }


    public static void main(String[] args) {
        String filePath = "http:asdf/asdfa/asdfasd/asdfasdf.png";
        System.out.println(CommonUtils.shared.getFileName(filePath));
    }
}
