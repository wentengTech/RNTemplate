package com.rntemplate.utils;


import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import com.facebook.react.bridge.ReactApplicationContext;
import com.makeramen.roundedimageview.RoundedImageView;
import com.rntemplate.R;
import com.rntemplate.components.fileView.LoadFileModel;
import com.rntemplate.components.image.imageView.YDImageView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ImageUtils {

    public static int dp2px(Context context, float dipValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5f);
    }


    public interface LoadImageDelegate {
        void loadImageSuccess(Bitmap bitmap);
    }

    // 加载本地图片
    public static void loadDrawableImage(Context context, String fileName, ImageView imageView) {
        if (!StringUtils.singleton.isEmpty(fileName) && !fileName.contains("http")) {
            Resources resources = context.getResources();
            if (resources == null) {
                return;
            }
            final int resourceId = resources.getIdentifier(fileName, "drawable", context.getPackageName());
            if (resourceId != 0) {
                Drawable drawable = resources.getDrawable(resourceId);
                if (drawable != null) {
                    imageView.setImageDrawable(drawable);
                }
            }
        }
    }


    // 加载网络图片
    public static void loadImage(Context context, ImageView imageView, String imageFilePath, String defaultImagePath) {
        loadImage(context, imageView, imageFilePath, defaultImagePath, null);
    }

    public static void loadImage(Context context, ImageView imageView, String imageFilePath, String defaultImagePath, LoadImageDelegate loadImageDelegate) {
        if (StringUtils.singleton.isEmpty(imageFilePath)) {
            loadDrawableImage(context, defaultImagePath, imageView);
        }
        // imageFilePath不为空
        else {
            String fileName = CommonUtils.shared.getFileName(imageFilePath);
            String localFilePath = context.getExternalCacheDir().getAbsolutePath() + fileName;
            File localFile = new File(localFilePath);

            // 本地文件存在
            if (localFile.exists()) {
                try {
                    Bitmap bitmap = CommonUtils.shared.getFitSampleBitmap(new FileInputStream(localFile));
                    imageView.setImageBitmap(bitmap);

                    if (loadImageDelegate != null) {
                        loadImageDelegate.loadImageSuccess(bitmap);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    loadDrawableImage(context, defaultImagePath, imageView);
                }
            }
            // 本地文件不存在
            else {
                LoadFileModel.loadPdfFile(imageFilePath, new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                        boolean flag;
                        InputStream is = null;
                        byte[] buf = new byte[2048];
                        int len = 0;
                        FileOutputStream fos = null;
                        try {
                            ResponseBody responseBody = response.body();
                            is = responseBody.byteStream();
                            long total = responseBody.contentLength();

                            File file1 = new File(context.getExternalCacheDir().getAbsolutePath());
                            if (!file1.exists()) {
                                file1.mkdirs();
                            }

                            File fileN = new File(localFilePath);

                            if (!fileN.exists()) {
                                boolean mkdir = fileN.createNewFile();
                            }
                            fos = new FileOutputStream(fileN);
                            long sum = 0;
                            while ((len = is.read(buf)) != -1) {
                                fos.write(buf, 0, len);
                                sum += len;
                                int progress = (int) (sum * 1.0f / total * 100);
                            }
                            fos.flush();

                            FileInputStream fileInputStream = new FileInputStream(fileN);
                            Bitmap bitmap = BitmapFactory.decodeStream(fileInputStream);
                            imageView.setImageBitmap(bitmap);

                            if (loadImageDelegate != null) {
                                loadImageDelegate.loadImageSuccess(bitmap);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            loadDrawableImage(context, defaultImagePath, imageView);
                        } finally {
                            try {
                                if (is != null)
                                    is.close();
                            } catch (IOException e) {
                            }
                            try {
                                if (fos != null)
                                    fos.close();
                            } catch (IOException e) {
                            }
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        loadDrawableImage(context, defaultImagePath, imageView);
                    }
                });
            }

        }
    }


    public static Bitmap drawable2Bitmap(Drawable drawable) {
        Bitmap bitmap = Bitmap
                .createBitmap(
                        drawable.getIntrinsicWidth(),
                        drawable.getIntrinsicHeight(),
                        drawable.getOpacity() != PixelFormat.OPAQUE ? Bitmap.Config.ARGB_8888
                                : Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, drawable.getIntrinsicWidth(),
                drawable.getIntrinsicHeight());
        drawable.draw(canvas);
        return bitmap;
    }

}
