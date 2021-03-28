package com.rntemplate.components.image;

import android.graphics.Bitmap;

import com.rntemplate.utils.StringUtils;


public class ImageItem {

    private String id;
    private String hashValue;
    private String path;

    private Boolean isUploading = false;
    private Integer assetsIndex = -1;

    private String filePath;
    private String filePathUrl;
    private String defaultImagePath;

    private Bitmap bitmap;

    private String identifier;

    //


    public ImageItem() {
        setIdentifier(StringUtils.singleton.generateUuid());
    }

    public ImageItem(Boolean isUploading, Integer assetsIndex, String filePath, String filePathUrl, String defaultImagePath, Bitmap bitmap) {
        this.isUploading = isUploading;
        this.assetsIndex = assetsIndex;
        this.filePath = filePath;
        this.defaultImagePath = defaultImagePath;
        this.filePathUrl = filePathUrl;
        this.bitmap = bitmap;

        setIdentifier(StringUtils.singleton.generateUuid());
    }

    //


    public String getDefaultImagePath() {
        return defaultImagePath;
    }

    public void setDefaultImagePath(String defaultImagePath) {
        this.defaultImagePath = defaultImagePath;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getHashValue() {
        return hashValue;
    }

    public void setHashValue(String hashValue) {
        this.hashValue = hashValue;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Boolean getUploading() {
        return isUploading;
    }

    public void setUploading(Boolean uploading) {
        isUploading = uploading;
    }

    public Integer getAssetsIndex() {
        return assetsIndex;
    }

    public void setAssetsIndex(Integer assetsIndex) {
        this.assetsIndex = assetsIndex;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePathUrl() {
        return filePathUrl;
    }

    public void setFilePathUrl(String filePathUrl) {
        this.filePathUrl = filePathUrl;
    }

    public Bitmap getBitmap() {
        return bitmap;
    }

    public void setBitmap(Bitmap bitmap) {
        this.bitmap = bitmap;
    }
}
