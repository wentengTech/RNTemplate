package com.rntemplate.utils;


import java.lang.reflect.Field;
import java.util.List;
import java.util.Random;
import java.util.UUID;

/**
 * 字符串工具栏
 *
 * @作者 温腾
 * @创建时间 2019年01月25日 16:32
 */
public enum StringUtils {

    singleton;

    ////////////////////////////////////////////////////////////////////////////////////////////////

    public String getString(Object value) {
        if (value == null) {
            return null;
        }
        return value.toString();
    }

    public String getStringWithDefault(Object value, String defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        String valueStr = value.toString();
        if (StringUtils.singleton.isEmpty(valueStr)) {
            return defaultValue;
        }

        return valueStr;
    }

    /*
    获取double的特定精度长度字符
     */
    public String getString(Double value, Integer precisonLength) {
        if (value == null) {
            return null;
        }
        return String.format("%." + precisonLength + "", value);
    }


    public Boolean isEmpty(String value) {
        return value == null || "".equals(value) || "null".equals(value);
    }


    public Boolean isEmpty(Object value) {
        if (value == null) {
            return true;
        }
        return isEmpty(value.toString());
    }


    public Boolean isEmpty(List<Object> values) {
        return values == null || values.isEmpty();
    }


    public Boolean isEmpty(Object[] values) {
        return values == null || values.length <= 0;
    }


    /*
    只要有一个为空都是true， 全部都不为空才是false
     */
    public Boolean isEmptyOr(Object... values) {
        if (isEmpty(values)) {
            return true;
        }
        for (Object item : values) {
            if (isEmpty(item)) {
                return true;
            }
        }
        return false;
    }

    /*
    只要有一个为空都是false，全部为空才是true
     */
    public Boolean isEmptyAnd(Object... values) {
        if (isEmpty(values)) {
            return true;
        }
        for (Object item : values) {
            if (!isEmpty(item)) {
                return false;
            }
        }
        return true;
    }


    /*
    uuvalue生成器
     */
    public String generateUuid() {
        String value = UUID.randomUUID().toString();
        value = value.substring(0, 8) + value.substring(9, 13) + value.substring(14, 18) + value.substring(19, 23) + value.substring(24);
        return value;
    }

    /*
    特定长度数字生成器
     */
    public String generateNumber(Integer length) {
        if (length == null || length <= 0) {
            return null;
        }

        StringBuilder value = new StringBuilder();

        for (Integer index = 0; index < length; index++) {
            value.append(new Random().nextInt(10));
        }
        return value.toString();
    }

    public String generateNumberWithoutRepeat(Integer length) {
        if (length == null || length <= 0) {
            return null;
        }

        StringBuilder value = new StringBuilder();
        String item;

        for (Integer index = 0; index < length; index++) {

            do {
                item = String.valueOf(new Random().nextInt(10));
            } while (value.indexOf(item) < 0);

            value.append(item);
        }
        return value.toString();
    }

    public String firstCharUpperCase(String value) {
        if (isEmpty(value)) {
            return null;
        }
        return value.substring(0, 1).toUpperCase();
    }


    public String firstCharLowerCase(String value) {
        if (isEmpty(value)) {
            return null;
        }
        return value.substring(0, 1).toLowerCase();
    }

    /*
    获取属性的get函数的名称
     */
    public String getGetMethodName(String fieldName) {
        if (isEmpty(fieldName)) {
            return null;
        }
        String getMethodName = "get" + firstCharUpperCase(fieldName);
        if (fieldName.length() > 1) {
            getMethodName += fieldName.substring(1);
        }
        return getMethodName;
    }

    public String getGetMethodName(Field field) {
        if (field == null) {
            return null;
        }
        return getGetMethodName(field.getName());
    }


    /*
    获取属性的set函数的名称
     */
    public String getSetMethodName(String fieldName) {
        if (isEmpty(fieldName)) {
            return null;
        }
        String setMethodName = "set" + firstCharUpperCase(fieldName);
        if (fieldName.length() > 1) {
            setMethodName += fieldName.substring(1);
        }
        return setMethodName;
    }

    public String getSetMethodName(Field field) {
        if (field == null) {
            return null;
        }
        return getSetMethodName(field.getName());
    }


    /**
     * 将字节数组转换为十六进制字符串
     *
     * @param src 字节数组
     * @return 十六进制字符串
     */
    public String bytesToHexString(byte[] src) {
        if (src == null || src.length <= 0) {
            return null;
        }
        StringBuilder stringBuilder = new StringBuilder("");
        for (byte aSrc : src) {
            int v = aSrc & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }

    /*
    用joinValue拼接values，成为单个string
     */
    public <T> String joinString(List<T> values, String joinValue) {
        if (isEmpty(values) || isEmpty(joinValue)) {
            return null;
        }
        StringBuilder value = new StringBuilder();

        for (int index = 0; index < values.size(); index++) {
            if (index > 0) {
                value.append(joinValue);
            }
            value.append(getString(values.get(index)));
        }
        return value.toString();
    }

    public static void main(String[] args) {
        System.out.println(StringUtils.singleton.generateUuid());
    }

}
























