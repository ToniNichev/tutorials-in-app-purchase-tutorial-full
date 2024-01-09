import jwt from "./jwt-generator.js";
import keys from "./keys/keys.js";

function getAppStoreContentApiToken() {
    const keyId = keys.appStoreContentKeyId;
    const issuerId = keys.issuerId;
    const privateKeyFileLocation = keys.appStoreContentPrivateKeyFileLocation;
    jwt(keyId, issuerId, privateKeyFileLocation, null);
}



function getAppStoreServerApiToken() {
    const keyId = keys.inAppPurchaseKeyId;
    const issuerId = keys.issuerId;
    const privateKeyFileLocation = keys.inAppPurchasePrivateKeyFileLocation;
    const bundleId = keys.bundleId;

    jwt(keyId, issuerId, privateKeyFileLocation, bundleId);
}

export default {
    getAppStoreServerApiToken,
    getAppStoreContentApiToken
}