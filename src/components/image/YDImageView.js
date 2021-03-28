import React, {Component} from 'react';
import {ActivityIndicator, findNodeHandle, Image, UIManager, View} from "react-native";
import {isDarkTheme, isIos, lowerAppVersion} from "../../utils/tools";
import NativeImageViewComponent from "./NativeImageViewComponent";

export default class YDImageView extends Component {


    static defaultProps = {
        // 默认关停darkable模式，需要的自行打开
        darkable: false,

        // 从什么版本开始，该图片内置在原生包了。validationVersion 建议设置为当前最新上架的版本号
        validVersion: null,

        // 默认不可预览图片
        previewable: false,
    };

    constructor(props) {
        super(props);

        this.state = {};
        this.imageViewRef = null;
        this.hasDidMounted = false;

        // 由于应用版本迭代，部分图片需放置于rn模块下
        this.localImages = {
            // xx: lowerAppVersion(this.props.validVersion) ? require('') : null
        }
    }


    componentDidMount() {
        this.updateIosFilePathInfo();
        this.hasDidMounted = true;
    }

    componentDidUpdate() {
        if (this.hasDidMounted) {
            this.updateIosFilePathInfo();
        }
    }

    // ios模块手动触发filePath的更新
    updateIosFilePathInfo() {
        if (isIos()) {
            if (this.props.filePath && this.props.filePath.indexOf('http') >= 0 && this.imageViewRef) {
                UIManager.dispatchViewManagerCommand(findNodeHandle(this.imageViewRef), UIManager['YDImageView'].Commands.onUpdate, [this.props.filePath]);
            }
        }
    }


    render() {
        return (
            <View style={this.props.style}>
                {(this.props.filePath || this.props.fileName) && !lowerAppVersion(this.props.validVersion) && (
                    <NativeImageViewComponent
                        ref={ref => this.imageViewRef = ref}
                        cornerRadius={this.props.cornerRadius}
                        filePath={this.props.filePath}
                        defaultImageName={this.props.defaultImageName}
                        previewable={this.props.previewable}
                        fileName={this.getFileNameWithDarkTheme()}
                        style={[{flex: 1, backgroundColor: 'transparent'}, this.props.style]}
                    />
                )}

                {lowerAppVersion(this.props.validVersion) && (
                    // 由于app版本过低，使用resources/image/version下的图片资源
                    <Image
                        PlaceholderContent={<ActivityIndicator/>}
                        style={[{flex: 1, backgroundColor: 'transparent', width: '100%', height: '100%'}, this.props.style]}
                        source={this.localImages[this.getFileNameWithDarkTheme()]}
                    />
                )}
            </View>
        );
    }

    // 暗黑模型下的图片显示追加 '_dark' 字符
    getFileNameWithDarkTheme() {
        return isDarkTheme() && this.props.darkable ? (this.props.fileName + '_dark') : this.props.fileName;
    }
}
