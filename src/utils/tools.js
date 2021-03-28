// 工具函数
import {Appearance, Platform} from 'react-native';
import DeviceInfo from "react-native-device-info";

// 判断是否是暗夜模式
export function isDarkTheme() {
    return Appearance.getColorScheme() === 'dark';
}

// 判断是否是苹果
export function isIos() {
    return Platform.OS === 'ios';
}

// 判断是否是安卓
export function isAndroid() {
    return Platform.OS === 'android';
}

// 判断是否是开发环境
export function isDevelopment() {
    return __DEV__;
}

// validationVersion 建议设置为当前最新上架的版本号
export function lowerAppVersion(validationVersion) {
    if (!validationVersion) {
        return false;
    }
    // if (__DEV__) {
    //   return false;
    // }
    return DeviceInfo.getBuildNumber() <= validationVersion;
}
