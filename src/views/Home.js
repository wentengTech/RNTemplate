import React, {useContext, useEffect} from 'react';
import {View, Text, Button} from 'react-native';
import {AuthContext} from "../store";
import {ToastUtils, RequestUtils} from '../utils'
import Icon from 'react-native-vector-icons/FontAwesome';
import Mock from 'mockjs'

export default function Home({navigation}) {

    const {logout} = useContext(AuthContext);
    const mockOption = {
        'list|1-10': [{
            'id|+1': 1
        }]
    }

    useEffect(() => {
        RequestUtils.mockGet(mockOption, 's?wd=dasf', null, resultJson => {
            console.log(resultJson)
        })
    }, [])

    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>这是主页</Text>
            <Button
                title="跳转去详情页面"
                onPress={() => navigation.navigate('details')}
            />
            <Icon name="rocket" size={30} color="#900"/>
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
