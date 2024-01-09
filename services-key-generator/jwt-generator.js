import jwt from "jsonwebtoken";
import fs from "fs";

const now = Math.round(new Date().getTime() / 1000);
const expirationTime = now + 500; // Set to 15 minutes (900 seconds)

export default async (keyId, issuerId, privateKeyFileLocation, bundleId) => {

    const privateKey = fs.readFileSync(privateKeyFileLocation);

    // Create the JWT header and payload
    const header = {
      'alg': 'ES256',
      'kid': keyId,
      'typ': 'JWT'
    };

    const payload = {
      "iss": issuerId,
      "iat": now,
      "exp": expirationTime,
      "aud": 'appstoreconnect-v1',
    };

    if(bundleId)
        payload["bid"] = bundleId;

    console.log('payload: ', payload);

    // Generate the JWT
    const token = jwt.sign(payload, privateKey, { header: header, algorithm: 'ES256' });

    console.log(`Generated JWT: ${token}`);
    return token;
}