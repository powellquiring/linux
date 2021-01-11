#!/bin/bash
set -e

# key protect stuff
KP_GUID=$(ibmcloud resource service-instances --output json | jq -r '.[]|select(.name=="dallas-account")|select(.sub_tyupe="kms")|.guid')
SSH_KEY_NAME=ssh_key
API_KEY_NAME=api_key

KEY_ID=''
key_id_find() {
  local key_name="$1"
  KEY_ID=$(ibmcloud kp -i $KP_GUID keys --output json | jq -r '.[]|select(.name=="'$key_name'")|.id')
}

PAYLOAD=""
key_store() {
  local key_name=$1
  local key_value="$2"
  PAYLOAD=""
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
  json=$(ibmcloud kp key show -i $KP_GUID $KEY_ID --output json)
  PAYLOAD=$(echo "$json" | jq -r .payload| base64 -d)
}


ssh_key_file_contents=$(cat ~/.ssh/id_rsa)
key_store $SSH_KEY_NAME "$ssh_key_file_contents"
echo "$PAYLOAD"

ibmcloud iam api-key-delete linux --force
apikey=$(ibmcloud iam api-key-create linux --output json | jq '.apikey')
key_store $API_KEY_NAME $apikey
echo $PAYLOAD
