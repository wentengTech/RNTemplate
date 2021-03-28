package com.rntemplate.components.image.imageView;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.ImageView;

import com.makeramen.roundedimageview.RoundedImageView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import okhttp3.ResponseBody;

public class YDImageView extends RoundedImageView {

    private Context context;

    // 图片是否可以预览
    private Boolean previewable = false;

    // 图片的bitmap数据
    private Bitmap bitmap;

    // 网络图片的路径
    private String filePath;

    // 网络图片显示前/显示失败情况下显示的本地图片
    private String defaultImageName;


    //
    //
    public YDImageView(Context context) {
        super(context);
        this.context = context;
        setScaleType(ImageView.ScaleType.CENTER_CROP);
        setCropToPadding(true);
    }

    //


    public String getDefaultImageName() {
        return defaultImageName;
    }

    public void setDefaultImageName(String defaultImageName) {
        this.defaultImageName = defaultImageName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Bitmap getBitmap() {
        return bitmap;
    }

    public void setBitmap(Bitmap bitmap) {
        this.bitmap = bitmap;
    }

    public Boolean getPreviewable() {
        return previewable;
    }

    public void setPreviewable(Boolean previewable) {
        this.previewable = previewable;
    }
}
