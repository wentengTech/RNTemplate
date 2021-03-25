// app的授权模块页面路由
import {NavigatorScreenOptions} from "./options";
import {createStackNavigator} from "@react-navigation/stack";
import React from "react";
import routerNames from "./routerNames";

// 创建导航栈
const StackNavigator = createStackNavigator();

// 授权模块页面的路由
import Login from './../views/Login'
import Register from "../views/Register";

export default function () {
    return (
        <StackNavigator.Navigator screenOptions={NavigatorScreenOptions}>
            <StackNavigator.Screen options={{title: '登录'}} name={routerNames.login} component={Login}/>
            <StackNavigator.Screen options={{title: '注册'}} name={routerNames.register} component={Register}/>
        </StackNavigator.Navigator>
    )
}
