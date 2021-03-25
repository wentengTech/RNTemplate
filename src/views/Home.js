import React, {useContext, useEffect} from 'react';
import {View, Text, Button} from 'react-native';
import {AuthContext} from "../store";

export default function Home({navigation}) {

    const {logout} = useContext(AuthContext);

    // useEffect(() => {
    //     console.log('home page')
    // }, [])

    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>这是主页</Text>
            <Button
                title="跳转去详情页面"
                onPress={() => navigation.navigate('details')}
            />
            <Button
                title="退出登录"
                onPress={logoutAction}
            />
        </View>
    );

    function logoutAction() {
        logout({userId: null})
    }
}
