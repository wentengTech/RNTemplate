import * as React from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import storeNames from "./storeNames";

// --
const AuthContext = React.createContext();

const authState = {
    // 认证授权信息是否初始化完成了,
    hasInitialed: false,

    // 登录的用户ID,
    userId: null,

}


const authReducer = (state, action) => {
    for (let key in authState) {
        if (action[key] !== undefined) {
            authState[key] = action[key]
            updateAsyncStorage(storeNames.authNames[key], authState[key])
        }
    }

    return {
        ...state,
        ...authState
    }
}

export {
    authState,
    authReducer,
    AuthContext
}


function updateAsyncStorage(key, value) {
    if (!key) {
        return
    }
    if (value) {
        AsyncStorage.setItem(key, value);
    } else {
        AsyncStorage.removeItem(key);
    }
}
