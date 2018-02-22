#!/bin/bash

echo -n "input your OTP code: "
read otp
payload="{\"otp\":\"$otp\"}"
curl -s localhost:8080/2fa -XPOST -H "Content-Type: application/json" -d "$payload"

