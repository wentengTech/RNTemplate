package com.rntemplate.utils;

import android.os.Handler;

import com.rntemplate.MainApplication;

import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 以后使用线程池管理线程
 *
 * @作者 温腾
 * @创建时间 2018年05月15日 下午9:23
 */
public enum ThreadUtils {

    singleton;

    // 回归主线程执行任务
    public void runInMainThread(Runnable runnable) {
        new Handler(MainApplication.getCurrentContext().getMainLooper()).post(runnable);
    }

    /**
     * 线程池，统一管理
     */
    private ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(5, 10, 200, TimeUnit.SECONDS, new LinkedBlockingDeque<>());

    public void async(WTRunnable actionObject) {

        // 创建线程接口对象
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                try {
                    actionObject.action();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        // 放到线程池种执行线程
        threadPoolExecutor.execute(runnable);
    }
}
