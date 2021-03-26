// app页面路由
import {NavigatorScreenOptions} from "./routerOptions";
import React from "react";
import {createStackNavigator} from "@react-navigation/stack";
import routerNames from "./routerNames";
import {tabBarNavigator, tabNavigatorOptions} from "./tabBarConfig";

// 创建导航栈
const StackNavigator = createStackNavigator();

// 各页面的路由
import Details from "../views/Details";

export default function () {
    return (
        <StackNavigator.Navigator screenOptions={NavigatorScreenOptions}>
            <StackNavigator.Screen name={routerNames.home} component={tabBarNavigator} options={({navigation, route}) => tabNavigatorOptions(route, navigation)}/>

            <StackNavigator.Screen options={{title: '详情'}} name={routerNames.details} component={Details}/>
        </StackNavigator.Navigator>
    )
}
