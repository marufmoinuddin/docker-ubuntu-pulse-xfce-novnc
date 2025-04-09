#!/bin/bash

# Directory for Firefox profile
FIREFOX_PROFILE_DIR="/home/$USERNAME/.mozilla/firefox"

# Create Firefox profile directory if it doesn't exist
mkdir -p "$FIREFOX_PROFILE_DIR"
PROFILE_PATH=$(find "$FIREFOX_PROFILE_DIR" -name "*.default" 2>/dev/null || echo "$FIREFOX_PROFILE_DIR/default")
mkdir -p "$PROFILE_PATH"

# Create Firefox preferences to accept insecure certificates
cat > "$PROFILE_PATH/user.js" << EOL
user_pref("network.stricttransportsecurity.preloadlist", false);
user_pref("security.cert_pinning.enforcement_level", 0);
user_pref("security.mixed_content.block_active_content", false);
user_pref("security.mixed_content.block_display_content", false);
user_pref("security.ssl.enable_ocsp_stapling", false);
user_pref("security.ssl.enable_ocsp_must_staple", false);
user_pref("security.ssl.require_safe_negotiation", false);
user_pref("security.tls.version.min", 1);
user_pref("security.enterprise_roots.enabled", true);
EOL

# Set proper ownership
chown -R $USERNAME:$USERNAME "$FIREFOX_PROFILE_DIR"
chmod -R 755 "$FIREFOX_PROFILE_DIR"

echo "Firefox certificate settings have been configured."