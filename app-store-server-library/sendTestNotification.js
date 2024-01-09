import { AppStoreServerAPIClient, Environment } from "@apple/app-store-server-library";
import fs from 'fs';
import keys from "./keys/keys.js";

const issuerId = keys.issuerId
const keyId = keys.keyId
const bundleId = keys.bundleId
const encodedKey = fs.readFileSync(keys.encodedKey)
const environment = Environment.SANDBOX

const client = new AppStoreServerAPIClient(encodedKey, keyId, issuerId, bundleId, environment)

try {
    const response = await client.requestTestNotification()
    console.log(response)
} catch (e) {
    console.error(e)
}


console.log("RUNNIING !!!");