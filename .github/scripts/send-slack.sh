#!/bin/bash
# Send Slack notification using template
# Usage: send-slack.sh <template> <channels> <token> [VAR=value ...]

set -e

TEMPLATE_FILE="$1"
CHANNELS="$2"
TOKEN="$3"
shift 3

# Read template
TEMPLATE_PATH=".github/slack-templates/${TEMPLATE_FILE}"
if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "❌ Template not found: $TEMPLATE_PATH"
  exit 1
fi

PAYLOAD=$(cat "$TEMPLATE_PATH")

# Replace variables passed as arguments (VAR=value format)
for VAR in "$@"; do
  KEY="${VAR%%=*}"
  VALUE="${VAR#*=}"
  # Escape special characters for JSON
  VALUE=$(echo "$VALUE" | sed 's/\\/\\\\/g; s/"/\\"/g')
  PAYLOAD=$(echo "$PAYLOAD" | sed "s|{{${KEY}}}|${VALUE}|g")
done

# Send to each channel
IFS=',' read -ra CHANNEL_ARRAY <<< "$CHANNELS"
for CHANNEL in "${CHANNEL_ARRAY[@]}"; do
  # Add channel to payload
  FINAL_PAYLOAD=$(echo "$PAYLOAD" | jq --arg channel "$CHANNEL" '. + {channel: $channel}')
  
  echo "📤 Sending to channel: $CHANNEL"
  
  RESPONSE=$(curl -s -X POST https://slack.com/api/chat.postMessage \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-type: application/json" \
    --data "$FINAL_PAYLOAD")
  
  # Check if successful
  if echo "$RESPONSE" | jq -e '.ok == true' > /dev/null 2>&1; then
    echo "✅ Message sent successfully"
  else
    echo "❌ Failed to send message:"
    echo "$RESPONSE" | jq '.error // .'
  fi
done

