import * as React from 'react';
import {DarkTheme, DefaultTheme, NavigationContainer} from '@react-navigation/native';
import {authRouters, routerNames, routers} from "./src/routers";
import {useEffect, useReducer} from "react";
import {authReducer, authState, storeNames, AuthContext} from "./src/store";
import AsyncStorage from '@react-native-async-storage/async-storage';
import {isDarkTheme} from "./src/utils/utils";
import {createBottomTabNavigator} from "@react-navigation/bottom-tabs";
import {createStackNavigator} from "@react-navigation/stack";

const TabNavigator = createBottomTabNavigator();

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


    // 登录授权信息的初始化函数
    const initialAuthInfo = async () => {
        let userId = await AsyncStorage.getItem(storeNames.stateNames.userId);
        dispatch({
            type: storeNames.authMethods.initial,
            hasInitialed: true,
            userId: userId
        })
    }

    useEffect(() => {
        // AsyncStorage.clear()
        initialAuthInfo();

        // 热更新的更新检测
        // AppHotUpdate.initial();
        // AppHotUpdate.checkVersionUpdate();
    }, []);


    return (
        <AuthContext.Provider value={authContext}>
            {state.hasInitialed && (
                (!state.userId ? (
                    <NavigationContainer key={routerNames.login} theme={isDarkTheme() ? DarkTheme : DefaultTheme}>
                        {authRouters()}
                    </NavigationContainer>
                ) : (
                    <NavigationContainer key={routerNames.home} theme={isDarkTheme() ? DarkTheme : DefaultTheme}>
                        {routers()}
                        {/*<TabNavigator.Navigator>*/}
                        {/*<TabNavigator.Screen name={routerNames.home} component={routers}/>*/}
                        {/*<TabNavigator.Screen name={routerNames.tabView1} component={routers}/>*/}
                        {/*</TabNavigator.Navigator>*/}
                    </NavigationContainer>
                ))
            )}
        </AuthContext.Provider>
    );

}

export default App;

// import * as React from 'react';
// import { Button, Text, View } from 'react-native';
// import { NavigationContainer } from '@react-navigation/native';
// import { createStackNavigator } from '@react-navigation/stack';
// import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
//

//
//
// export default function App() {
//     return (
//         <NavigationContainer>
//             <Tab.Navigator>
//                 <Tab.Screen name="Home" component={HomeStackScreen} />
//                 <Tab.Screen name="Settings" component={SettingsStackScreen} />
//             </Tab.Navigator>
//         </NavigationContainer>
//     );
// }
