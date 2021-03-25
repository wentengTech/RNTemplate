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
            // tabBarOptions={{
            //     activeTintColor: isDarkTheme() ? 'white' : 'gray',
            //     inactiveTintColor: isDarkTheme() ? 'red' : 'red',
            //     style: isIos() ? null : {
            //         paddingBottom: 12,
            //         height: 62,
            //     },
            // }}
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
        // headerShown: !(routeName === PageRouterNames.tab_statistic || routeName === PageRouterNames.tab_product),
        // headerLeft: () => (
        //     <TouchableOpacity style={{
        //         padding: value.small_interval,
        //         marginLeft: value.small_interval,
        //     }} onPress={() => {
        //         navigation.navigate(PageRouterNames.base.qr_code_scanner_view);
        //     }}>
        //         <Icon style={{color: color.label_color}} size={24} name="scan-outline"/>
        //     </TouchableOpacity>
        // ),
        // headerRight: () => (
        //     <TouchableOpacity style={{
        //         padding: value.small_interval,
        //         marginRight: value.small_interval,
        //     }} onPress={() => {
        //         navigation.navigate(PageRouterNames.notification.list);
        //     }}>
        //         <Icon style={{color: color.label_color}} size={24} name="notifications-outline"/>
        //         {msgCountInfo != null && msgCountInfo > 0 && (
        //             <Badge value={msgCountInfo} status="error"
        //                    containerStyle={{
        //                        position: 'absolute',
        //                        top: 2,
        //                        right: 2,
        //                    }}
        //             />
        //         )}
        //     </TouchableOpacity>
        // ),
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
            // // 自定义收银
            // if (route.name === PageRouterNames.tab_cashier) {
            //     return null;
            // }
            // let iconName;
            // let focusedImageName;
            //
            // if (route.name === PageRouterNames.tab_home) {
            //     iconName = 'home-outline';
            //     focusedImageName = 'home_focused';
            // } else if (route.name === PageRouterNames.tab_mine) {
            //     iconName = 'person-outline';
            //     focusedImageName = 'mine_focused';
            // } else if (route.name === PageRouterNames.tab_product) {
            //     iconName = 'cube-outline';
            //     focusedImageName = 'product_focused';
            // } else if (route.name === PageRouterNames.tab_statistic) {
            //     iconName = 'stats-chart-outline';
            //     focusedImageName = 'statistic_focused';
            // }
            //
            // You can return any component that you like here!
            // return <Icon name={iconName} size={size} color={color} />;
            //
            // // 未选中处理
            // if (!focused) {
            //     return <Icon name={iconName} size={size} color={color} />;
            // }
            // // 选中处理
            // else {
            //     return (
            //         <View style={[{width: size, height: size}]}>
            //             <SesameImage fileName={focusedImageName} darkable={false} />
            //         </View>
            //     );
            // }
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

// // 设定tab item的title样式
// function getTabBarTextStyle(color, size) {
//     return {
//         color: color,
//         fontSize: size,
//         // paddingBottom: isIos() && NativeModules.ReactNativeCommunication.heightOfSafeAreaBottom <= 0 ? 3 : 0,
//     };
// }
