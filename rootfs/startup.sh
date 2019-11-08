#! /bin/bash

# If the repository GPG keypair doesn't exist, create it.
if [[ ! -f /opt/aptly/aptly.sec ]] || [[ ! -f /opt/aptly/aptly.pub ]]; then
  cat << EOF > /opt/gpg_batch
%echo Generating a GPG key, might take a while
Key-Type: RSA
Key-Length: 4096
Subkey-Length: 4096
Name-Real: ${FULL_NAME}
Name-Email: ${EMAIL_ADDRESS}
Expire-Date: 0
Passphrase: ${GPG_PASSWORD}
%pubring /opt/aptly/aptly.pub
%secring /opt/aptly/aptly.sec
%commit
%echo done
EOF
  # If your system doesn't have a lot of entropy this may, take a long time
  # Google how-to create "artificial" entropy if this gets stuck
  gpg1 --batch --gen-key /opt/gpg_batch
fi

# Aptly looks in /root/.gnupg for default keyrings
mkdir -p /root/.gnupg
ln -sf /opt/aptly/aptly.sec /root/.gnupg/secring.gpg
ln -sf /opt/aptly/aptly.pub /root/.gnupg/pubring.gpg

# Export the GPG Public key
if [[ ! -f /opt/aptly/public/aptly_repo_signing.key ]]; then
  mkdir -p /opt/aptly/public
  gpg1 --export --armor --output /opt/aptly/public/aptly_repo_signing.key
fi

# Generate Nginx Config
cat << EOF > /etc/nginx/conf.d/default.conf
server {
  root /opt/aptly/public;
  server_name _;
  access_log /dev/stdout;
  error_log /dev/stderr;

  location / {
    autoindex on;
  }
}
EOF

# Start Nginx
echo "Starting nginx"
exec nginx -g 'daemon off;'