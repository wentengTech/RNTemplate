import {TransitionPresets} from '@react-navigation/stack';

const NavigatorScreenOptions = {
    ...TransitionPresets.SlideFromRightIOS,
    headerBackTitle: '返回',
    // headerStyle: isIos() ? null : {
    //     height: 47,
    // },
    // headerTitleStyle: isIos() ? null : {
    //     fontSize: fontSize.bigger,
    // },
};

export {
    NavigatorScreenOptions
}

