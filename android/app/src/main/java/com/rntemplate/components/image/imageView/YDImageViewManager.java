package com.rntemplate.components.image.imageView;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.rntemplate.MainApplication;
import com.rntemplate.components.image.ImageItem;
import com.rntemplate.components.image.PreviewImageUtils;
import com.rntemplate.utils.CommonUtils;
import com.rntemplate.utils.ImageUtils;
import com.rntemplate.utils.StringUtils;
import com.rntemplate.utils.ThreadUtils;

public class YDImageViewManager extends SimpleViewManager<YDImageView> {

    ReactApplicationContext mCallerContext;

    public YDImageViewManager(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return "YDImageView";
    }

    @NonNull
    @Override
    protected YDImageView createViewInstance(@NonNull ThemedReactContext reactContext) {
        YDImageView imageView = new YDImageView(reactContext);
        imageView.setOnClickListener(v -> {
            if (imageView.getPreviewable()) {
                ImageItem imageItem = new ImageItem(false, 0, imageView.getFilePath(), imageView.getFilePath(), imageView.getDefaultImageName(), imageView.getBitmap());
                PreviewImageUtils.singleton.previewImage(imageItem, imageView);
            }
        });
        return imageView;
    }

    @ReactProp(name = "previewable")
    public void previewable(YDImageView imageView, Boolean previewable) {
        imageView.setPreviewable(previewable);
    }

    @ReactProp(name = "cornerRadius")
    public void cornerRadius(YDImageView imageView, int cornerRadius) {
        if (cornerRadius <= 0) {
            return;
        }
        imageView.setCornerRadius(CommonUtils.shared.dpToPx(mCallerContext, cornerRadius));
    }

    @ReactProp(name = "defaultImageName")
    public void setDefaultImageName(YDImageView imageView, String defaultImageName) {
        imageView.setDefaultImageName(defaultImageName);
        ImageUtils.loadDrawableImage(mCallerContext, defaultImageName, imageView);
    }

    @ReactProp(name = "filePath")
    public void setFilePath(YDImageView view, String filePath) {
        if (!StringUtils.singleton.isEmpty(filePath) && filePath.contains("http")) {
            view.setFilePath(filePath);
            ThreadUtils.singleton.async(() -> {
                ImageUtils.loadImage(mCallerContext, view, filePath, view.getDefaultImageName(), new ImageUtils.LoadImageDelegate() {
                    @Override
                    public void loadImageSuccess(Bitmap bitmap) {
                        view.setBitmap(bitmap);
                    }
                });
            });
        }
    }

    @ReactProp(name = "fileName")
    public void setFileName(YDImageView view, String fileName) {
        ImageUtils.loadDrawableImage(mCallerContext, fileName, view);
    }


}
