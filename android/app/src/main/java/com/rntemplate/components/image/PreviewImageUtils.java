package com.rntemplate.components.image;

import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomViewTarget;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.davemorrissey.labs.subscaleview.ImageSource;
import com.davemorrissey.labs.subscaleview.ImageViewState;
import com.davemorrissey.labs.subscaleview.SubsamplingScaleImageView;
import com.github.iielse.imageviewer.ImageViewerBuilder;
import com.github.iielse.imageviewer.adapter.ItemType;
import com.github.iielse.imageviewer.core.DataProvider;
import com.github.iielse.imageviewer.core.ImageLoader;
import com.github.iielse.imageviewer.core.Photo;
import com.github.iielse.imageviewer.core.Transformer;
import com.github.iielse.imageviewer.widgets.video.ExoVideoView2;
import com.rntemplate.MainApplication;
import com.rntemplate.components.image.imageView.YDImageView;
import com.rntemplate.utils.ImageUtils;
import com.rntemplate.utils.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;

public enum PreviewImageUtils {
    singleton;

    class ImageData implements Photo {

        public ImageItem imageItem;

        public ImageData(ImageItem imageItem) {
            this.imageItem = imageItem;
        }

        @Override
        public long id() {
            return imageItem.getAssetsIndex();
        }

        @Override
        public int itemType() {
            return ItemType.PHOTO;
        }
    }

    public void previewImage(int index, List<ImageItem> imageItemList, List<YDImageView> YDImageViewList) {
        List<Photo> photoList = new ArrayList<>();
        for (ImageItem imageItem : imageItemList) {
            photoList.add(new ImageData(imageItem));
        }

        ImageViewerBuilder imageViewerBuilder = new ImageViewerBuilder(
                MainApplication.getCurrentActivity(),
                new ImageLoader() {
                    @Override
                    public void load(ImageView imageView, Photo photo, RecyclerView.ViewHolder viewHolder) {
                        ImageData imageData = (ImageData) photo;
                        if (imageData != null) {
                            if (imageData.imageItem.getBitmap() != null) {
                                imageView.setImageBitmap(imageData.imageItem.getBitmap());
                            } else if (!StringUtils.singleton.isEmpty(imageData.imageItem.getFilePathUrl())) {
                                ImageUtils.loadImage(MainApplication.getCurrentContext(), imageView, imageData.imageItem.getFilePathUrl(), imageData.imageItem.getDefaultImagePath());
                            }
                        }
                    }

                    @Override
                    public void load(SubsamplingScaleImageView subsamplingScaleImageView, Photo photo, RecyclerView.ViewHolder viewHolder) {
                        ImageData imageData = (ImageData) photo;
                        if (imageData != null) {
                            if (imageData.imageItem.getBitmap() != null) {
                                subsamplingScaleImageView.setImage(ImageSource.bitmap(imageData.imageItem.getBitmap()));
                            } else if (!StringUtils.singleton.isEmpty(imageData.imageItem.getFilePathUrl())) {
                                Glide.with(MainApplication.getCurrentContext()).load(imageData.imageItem.getFilePathUrl()).into(new CustomViewTarget<SubsamplingScaleImageView, Drawable>(subsamplingScaleImageView) {
                                    @Override
                                    public void onLoadFailed(@Nullable Drawable errorDrawable) {

                                    }

                                    @Override
                                    public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                                        Bitmap bitmap = ImageUtils.drawable2Bitmap(resource);
                                        subsamplingScaleImageView.setImage(ImageSource.bitmap(bitmap));
                                    }

                                    @Override
                                    protected void onResourceCleared(@Nullable Drawable placeholder) {

                                    }
                                });
                            }
                        }
                    }

                    @Override
                    public void load(ExoVideoView2 exoVideoView2, Photo photo, RecyclerView.ViewHolder viewHolder) {
                    }
                },
                new DataProvider() {
                    @Override
                    public List<Photo> loadInitial() {
                        return photoList;
                    }

                    @Override
                    public void loadAfter(long l, Function1<? super List<? extends Photo>, Unit> function1) {

                    }

                    @Override
                    public void loadBefore(long l, Function1<? super List<? extends Photo>, Unit> function1) {

                    }
                },
                new Transformer() {
                    @Override
                    public ImageView getView(long l) {
                        return YDImageViewList.get((int) l);
                    }
                },
                index);
        imageViewerBuilder.show();
    }


    public void previewImage(ImageItem imageItem, YDImageView YDImageView) {
        previewImage(0, Collections.singletonList(imageItem), Collections.singletonList(YDImageView));
    }
}
