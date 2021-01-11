# key protect stuff
echo '*' get key protect guid
KP_GUID=$(ibmcloud resource service-instances --output json | jq -r '.[]|select(.name=="dallas-account")|select(.sub_tyupe="kms")|.guid')
SSH_KEY_NAME=ssh_key
API_KEY_NAME=api_key

KEY_ID=''
key_id_find() {
  local key_name="$1"
  KEY_ID=$(ibmcloud kp -i $KP_GUID keys --output json | jq -r '.[]|select(.name=="'$key_name'")|.id')
}

key_payload() {
  key_name="$1"
  PAYLOAD=""
  key_id_find $key_name
  json=$(ibmcloud kp key show -i $KP_GUID $KEY_ID --output json)
  PAYLOAD=$(echo "$json" | jq -r .payload| base64 -d)
}
