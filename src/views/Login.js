import React, {useContext, useEffect} from 'react';
import {View, Text, Button} from 'react-native';
import {AuthContext} from "../store";

export default function Login({navigation}) {

    const {login} = useContext(AuthContext);

    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>这是登录页面</Text>
            <Button
                title="跳转去注册页面"
                onPress={() => navigation.navigate('register')}
            />

            <Button title="登录"
                    onPress={loginAction}
            />
        </View>
    )

    function loginAction() {
        login({userId: 'development_user_id'})
    }
}
