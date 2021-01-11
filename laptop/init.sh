#!/bin/bash
set -o pipefail

# include common functions
source $(dirname "$0")/../common.sh

PAYLOAD=""
key_store() {
  local key_name=$1
  local key_value="$2"
  key_id_find $key_name
  echo '*' Delete the existing key protect key: $key_name
  if [ x$KEY_ID = x ]; then
    echo key $key_name does not exist
  else
    ibmcloud kp key delete -i $KP_GUID $KEY_ID
  fi

  echo '*' create the new key protect key
  base64_value=$(echo "$key_value" | base64)
  ibmcloud kp key create $key_name -i $KP_GUID --key-material "$base64_value" --standard-key

  echo '*' key contents
  key_id_find $key_name
}


ssh_key_file_contents=$(cat ~/.ssh/id_rsa)
key_store $SSH_KEY_NAME "$ssh_key_file_contents"
key_payload $SSH_KEY_NAME
echo "$PAYLOAD"

ibmcloud iam api-key-delete linux --force
apikey=$(ibmcloud iam api-key-create linux --output json | jq '.apikey')
key_store $API_KEY_NAME $apikey
key_payload $API_KEY_NAME
echo $PAYLOAD
