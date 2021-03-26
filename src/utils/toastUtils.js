import React from 'react';
import RootToast from 'react-native-root-toast';
import RootSiblings from 'react-native-root-siblings';
import {View, Text, ActivityIndicator, StyleSheet} from "react-native";
import Icon from 'react-native-vector-icons/FontAwesome';

let sibling = undefined;
const toast = {
    show: (message, options) => {
        RootToast.show(message, {
            duration: RootToast.durations.SHORT,
            position: RootToast.positions.CENTER,
            animation: true,
            hideOnPress: true,
            delay: 0,
            ...options
        });
    },


    showSuccess: (message) => {
        RootToast.show(
            <View style={styles.container}>
                <Icon name='check' size={47} color={'#fff'}/>
                <Text style={styles.message}>{message}</Text>
            </View>,
            {
                duration: RootToast.durations.SHORT,
                position: RootToast.positions.CENTER,
                shadow: true,
                animation: true,
                hideOnPress: true,
                delay: 0,
            });
    },

    showFailure: (message) => {
        RootToast.show(
            <View style={styles.container}>
                <Icon name='close' size={52} color={'#fff'}/>
                <Text style={styles.message}>{message}</Text>
            </View>,
            {
                duration: RootToast.durations.SHORT,
                position: RootToast.positions.CENTER,
                shadow: true,
                animation: true,
                hideOnPress: true,
                delay: 0,
            });
    },


    showLoading: (message) => {
        if (sibling) {
            toast.hideLoading();
        }
        sibling = new RootSiblings(
            <View style={styles.maskStyle}>
                <View style={styles.backViewStyle}>
                    <ActivityIndicator size="large" color="white"/>
                    <Text style={styles.message}>{message}</Text>
                </View>
            </View>,
        );
    },
    hideLoading: () => {
        if (sibling) {
            sibling.destroy();
            sibling = null;
        }
    },
}
export default toast;

const styles = StyleSheet.create({
    container: {
        width: 120,
        minHeight: 110,
        alignItems: 'center',
        justifyContent: 'center',
    },
    message: {
        color: '#fff',
        fontSize: 15,
        marginTop: 12,
        textAlign: 'center',
        lineHeight: 21,
    },

    maskStyle: {
        position: 'absolute',
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        backgroundColor: 'rgba(0, 0, 0, 0.3)',
        width: '100%',
        height: '100%',
        alignItems: 'center',
        justifyContent: 'center',
    },
    backViewStyle: {
        backgroundColor: '#111',
        width: 130,
        height: 130,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 12,
    },
});
