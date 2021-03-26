//
import DEVELOPMENT from './configDevelopment'
import PRODUCTION from './configProduction'

import {isDevelopment} from "../utils/tools";

// 根据环境配置变量
const configObj = {};
for (let key in DEVELOPMENT) {
    configObj[key] = isDevelopment() ? DEVELOPMENT[key] : PRODUCTION[key]
}

export default configObj;
