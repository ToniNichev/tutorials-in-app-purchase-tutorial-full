import { AppStoreServerAPIClient, Environment } from "@apple/app-store-server-library";
import fs from 'fs';

const issuerId = "69a6de78-7344-47e3-e053-5b8c7c11a4d1"
const keyId = "4U5MB9A477"
const bundleId = "com.toninichev.Blue.InAppPurchaseTutorial"
const encodedKey = fs.readFileSync("./assets/SubscriptionKey_4U5MB9A477.p8")
const environment = Environment.SANDBOX

const client = new AppStoreServerAPIClient(encodedKey, keyId, issuerId, bundleId, environment)

try {
    const response = await client.requestTestNotification()
    console.log(response)
} catch (e) {
    console.error(e)
}