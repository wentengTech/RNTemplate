// 工具函数
import {Appearance, Platform} from 'react-native';

export function isDarkTheme() {
    return Appearance.getColorScheme() === 'dark';
}

export function isIos() {
    return Platform.OS === 'ios';
}

export function isAndroid() {
    return Platform.OS === 'android';
}

export function isDevelopment() {
    return __DEV__;
}
