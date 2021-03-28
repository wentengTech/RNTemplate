import React, {Component} from 'react';
import {View, Text} from 'react-native';
import {YDImageView} from '../components'

export default class TabView1 extends Component {

    render() {
        return (
            <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
                <Text>这是TabView1页面</Text>
                <YDImageView previewable={true} style={{height: 57, width: 57}} filePath={'https://img.alicdn.com/imgextra/https://img.alicdn.com/imgextra/i3/2206386464998/O1CN01IFBhk01mn89yVVhig_!!2206386464998.jpg_430x430q90.jpg'} defaultImageName={'delete_database'}/>
            </View>
        )
    }
}
