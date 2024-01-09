<?php
header('Status: 200');
header("HTTP/1.1 200 OK"); 

ini_set('display_errors', 1);
error_reporting(E_ALL);


// Download the certificate -> https://www.apple.com/certificateauthority/AppleRootCA-G3.cer
// Convert it to .PEM file, run on macOS terminal ->  ```bash openssl x509 -in AppleRootCA-G3.cer -out apple_root.pem```

$pem = file_get_contents('./assets/apple_root.pem');
// $data = file_get_contents('./test.json'); // replace with file_get_contents('php://input');
$data = file_get_contents('php://input'); // replace with file_get_contents('php://input');
$json = json_decode($data);


$header_payload_secret = explode('.', $json->signedPayload);

//------------------------------------------
// Header
//------------------------------------------
$header = json_decode(base64_decode($header_payload_secret[0]));

$algorithm = $header->alg;
$x5c = $header->x5c; // array
$certificate = $x5c[0];
$intermediate_certificate = $x5c[1];
$root_certificate = $x5c[2];

$certificate =
      "-----BEGIN CERTIFICATE-----\n"
    . $certificate
    . "\n-----END CERTIFICATE-----";

$intermediate_certificate =
      "-----BEGIN CERTIFICATE-----\n"
    . $intermediate_certificate
    . "\n-----END CERTIFICATE-----";

$root_certificate =
      "-----BEGIN CERTIFICATE-----\n"
    . $root_certificate
    . "\n-----END CERTIFICATE-----";

//------------------------------------------
// Verify the notification request   
//------------------------------------------
if (openssl_x509_verify($intermediate_certificate, $root_certificate) != 1){ 
    echo 'Intermediate and Root certificate do not match';
    exit;
}

// Verify again with Apple root certificate
if (openssl_x509_verify($root_certificate, $pem) == 1){
    
    //------------------------------------------
    // Payload
    //------------------------------------------
    // https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
    // https://developer.apple.com/documentation/appstoreservernotifications/subtype

    $payload = json_decode(base64_decode($header_payload_secret[1]));
    $notificationType = $payload->notificationType;
    $subtype = $payload->subtype;

    

    $transactionInfo = $payload->data->signedTransactionInfo;
    $ti = explode('.', $transactionInfo);
    
    $data = json_decode(base64_decode($ti[1]));

    // var_dump($payload); // this will contain our originalTransactionId
    file_put_contents("./data.txt", PHP_EOL . PHP_EOL . '=====================================' . PHP_EOL, FILE_APPEND);
    file_put_contents("./data.txt", print_r($payload, true),  FILE_APPEND);
    file_put_contents("./data.txt", '-------------------------------------' . PHP_EOL, FILE_APPEND);
    file_put_contents("./data.txt", print_r($data, true), FILE_APPEND);

    if($notificationType == "SUBSCRIBED") {
    }
    if ($notificationType == "EXPIRED" || $notificationType == "REFUND") {
    }
} else {
    echo 'Header is not valid';
    exit;
}
