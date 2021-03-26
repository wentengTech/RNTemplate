import * as React from 'react';
import {DarkTheme, DefaultTheme, NavigationContainer} from '@react-navigation/native';
import {routersOfAuth, routerNames, routers} from "./src/routers";
import {useEffect, useReducer} from "react";
import {authReducer, authState, storeNames, AuthContext} from "./src/store";
import AsyncStorage from '@react-native-async-storage/async-storage';
import {isDarkTheme} from "./src/utils/tools";
import {RootSiblingParent} from 'react-native-root-siblings';

function App() {

    // reducer
    const [state, dispatch] = useReducer(authReducer, authState);

    // 监听其他页面调用的login和logout函数，再统一dispatch
    const authContext = React.useMemo(() => ({
        login: async data => {
            dispatch({...data, type: storeNames.authMethods.login})
        },
        logout: async data => {
            dispatch({...data, type: storeNames.authMethods.logout})
        }
    }))


    // 登录授权信息的初始化函数, 获取缓存的授权信息，并调用initial相关初始化函数
    const initialAuthInfo = async () => {
        let userId = await AsyncStorage.getItem(storeNames.authNames.userId);
        dispatch({
            type: storeNames.authMethods.initial,
            hasInitialed: true,
            userId: userId
        })
    }


    useEffect(() => {
        initialAuthInfo();
    }, []);


    return (
        <AuthContext.Provider value={authContext}>
            {state.hasInitialed ?
                <RootSiblingParent>
                    {!state.userId ?
                        <NavigationContainer key={routerNames.login} theme={isDarkTheme() ? DarkTheme : DefaultTheme}>
                            {routersOfAuth()}
                        </NavigationContainer>
                        :
                        <NavigationContainer key={routerNames.home} theme={isDarkTheme() ? DarkTheme : DefaultTheme}>
                            {routers()}
                        </NavigationContainer>
                    }
                </RootSiblingParent>
                : null}
        </AuthContext.Provider>
    );

}

export default App;
