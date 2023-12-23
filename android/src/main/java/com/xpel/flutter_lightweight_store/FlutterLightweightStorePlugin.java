package com.xpel.flutter_lightweight_store;

import androidx.annotation.NonNull;

import com.tesla.modules.store.TlStoreManager;
import com.tesla.modules.store.util.TlStoreLogger;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterLightweightStorePlugin
 */
public class FlutterLightweightStorePlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_lightweight_store");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String method = call.method;
        Object arguments = call.arguments;
        TlStoreLogger.log("[FlutterLightweightStorePlugin] receive: " + method + ", arguments: " + arguments);
        // 约定一定要传 Map 类型参数, 空也不行
        if (!(arguments instanceof Map)) {
            _sendError(result, 3000300, null, "arguments type should be a hash map.");
            return;
        }
        try {
            handleMethod(method, (Map) arguments, result);
        } catch (Exception e) {
            _sendError(result, 3000301, null, "exception: " + e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private static void _sendError(@NonNull Result result, int code, String msg, String error) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("code", code);
        if (msg != null) {
            resultMap.put("msg", msg);
        }
        if (error != null) {
            resultMap.put("error", error);
        }
        _send(result, resultMap);
    }

    private static void _sendSuccess(@NonNull Result result, Object data) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("code", 200);
        if (data != null) {
            resultMap.put("data", data);
        }
        _send(result, resultMap);
    }

    private static void _send(@NonNull Result result, @NonNull Map map) {
        TlStoreLogger.log("[FlutterLightweightStorePlugin] send: " + map);
        result.success(map);
    }


    private void handleMethod(@NonNull String method, @NonNull Map arguments, @NonNull Result result) {
        JSONObject args = new JSONObject(arguments);
        String module = args.optString("module");
        if (module.isEmpty()) {
            _sendError(result, 3000302, null, "arguments should have a 'module' KV.");
            return;
        }
        if ("register".equals(method)) {
            String aesKey = args.optString("aesKey");
            String aesIV = args.optString("aesIV");
            Boolean isAsyncApply = args.optBoolean("isAsyncApply");
            Boolean isKeepKeyClearText = args.optBoolean("isKeepKeyClearText");
            TlStoreManager.getInstance().register(module, aesKey.isEmpty() ? null : aesKey, aesIV.isEmpty() ? null : aesIV, isAsyncApply, isKeepKeyClearText);
            _sendSuccess(result, null);
            return;
        }
        if ("unregister".equals(method)) {
            TlStoreManager.getInstance().unregister(module);
            _sendSuccess(result, null);
            return;
        }
        String key = args.optString("key");
        if (key.isEmpty()) {
            _sendError(result, 3000303, null, "arguments should have a 'key' KV in get* method.");
            return;
        }
        if ("contains".equals(method)) {
            boolean retValue = TlStoreManager.getInstance().contains(module, key);
            _sendSuccess(result, retValue);
            return;
        }
        if ("removeKey".equals(method)) {
            TlStoreManager.getInstance().removeKey(module, key);
            _sendSuccess(result, true); // true always now ...
            return;
        }
        if ("getString".equals(method)) {
            String retValue = TlStoreManager.getInstance().getString(module, key, null);
            _sendSuccess(result, retValue);
            return;
        }
        if ("getInt".equals(method) || "getLong".equals(method)) {
            long retValue = TlStoreManager.getInstance().getLong(module, key, 0);
            boolean isKeyExisted = true;
            if (retValue == 0) {
                isKeyExisted = TlStoreManager.getInstance().contains(module, key);
            }
            _sendSuccess(result, isKeyExisted ? retValue : null);
            return;
        }
        if ("getFloat".equals(method) || "getDouble".equals(method)) {
            double retValue = TlStoreManager.getInstance().getDouble(module, key, 0.0);
            boolean isKeyExisted = true;
            if (retValue == 0.0) {
                isKeyExisted = TlStoreManager.getInstance().contains(module, key);
            }
            _sendSuccess(result, isKeyExisted ? retValue : null);
            return;
        }
        if ("getBoolean".equals(method)) {
            boolean retValue = TlStoreManager.getInstance().getBoolean(module, key, false);
            boolean isKeyExisted = true;
            if (!retValue) {
                isKeyExisted = TlStoreManager.getInstance().contains(module, key);
            }
            _sendSuccess(result, isKeyExisted ? retValue : null);
            return;
        }

        if (!args.has("value")) {
            _sendError(result, 3000304, null, "arguments should have a 'value' KV in set* method.");
            return;
        }
        if ("setString".equals(method)) {
            TlStoreManager.getInstance().setString(module, key, args.optString("value"));
            _sendSuccess(result, null);
            return;
        }
        if ("setInt".equals(method) || "setLong".equals(method)) {
            TlStoreManager.getInstance().setLong(module, key, args.optLong("value"));
            _sendSuccess(result, null);
            return;
        }
        if ("setFloat".equals(method) || "setDouble".equals(method)) {
            TlStoreManager.getInstance().setDouble(module, key, args.optDouble("value"));
            _sendSuccess(result, null);
            return;
        }
        if ("setBoolean".equals(method)) {
            TlStoreManager.getInstance().setBoolean(module, key, args.optBoolean("value"));
            _sendSuccess(result, null);
            return;
        }
        result.notImplemented();
    }
}
