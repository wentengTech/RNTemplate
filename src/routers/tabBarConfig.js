import React from "react";
import {routerNames} from "./index";
import {getFocusedRouteNameFromRoute} from '@react-navigation/native';
import {Text, Image} from "react-native";
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';

// 底部模块页面
import Home from "../views/Home";
import TabView1 from "../views/TabView1";
import TabView2 from "../views/TabView2";

const BottomTabNavigator = createBottomTabNavigator();

export function tabBarNavigator(props) {
    return (
        <BottomTabNavigator.Navigator
            screenOptions={({navigation, route}) => tabBarScreenOptions(navigation, route)}
            tabBarOptions={{
                activeTintColor: 'red',
                inactiveTintColor: 'grey',
            }}
        >
            <BottomTabNavigator.Screen name={routerNames.tab.home} component={Home}/>
            <BottomTabNavigator.Screen name={routerNames.tab.tabView1} component={TabView1}/>
            <BottomTabNavigator.Screen name={routerNames.tab.tabView2} component={TabView2}/>
        </BottomTabNavigator.Navigator>
    )
}


export function tabNavigatorOptions(route, navigation, msgCountInfo) {
    const routeName = getFocusedRouteNameFromRoute(route);
    return {
        headerTitle: getHomeStackNavigatorTitle(routeName),
    };
}


//
function tabBarScreenOptions(navigation, route) {
    return {
        tabBarLabel: ({focused, color, size}) => {
            return <Text style={{color: color, fontSize: size}}>{getHomeStackNavigatorTitle(route.name)}</Text>
        },
        tabBarIcon: ({focused, color, size}) => {
            return <Image source={focused ? require('./../resources/image/dashboard_focus.png') : require('./../resources/image/dashboard.png')} style={{width: size, height: size}}/>
        },
    };
}


// 设定tab页面的标题信息
function getHomeStackNavigatorTitle(routeName) {
    switch (routeName) {
        case routerNames.tab.home :
            return '主页';
        case routerNames.tab.tabView1 :
            return '分页1';
        case routerNames.tab.tabView2 :
            return '分页2';
        default:
            return '主页';
    }
}

