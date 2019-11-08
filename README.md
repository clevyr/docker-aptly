# Docker aptly

[![Badge](https://images.microbadger.com/badges/image/clevyr/aptly.svg)](https://microbadger.com/images/clevyr/aptly "Get your own image badge on microbadger.com")

This is a Dockerized version of [aptly](https://aptly.info) to maintain APT repositories.

## Environment Variables

|   Variable    |                      Details                       |     Example     |
| ------------- | -------------------------------------------------- | --------------- |
| FULL_NAME     | the full name to be used in GPG key generation     | `Clevyr CI`     |
| EMAIL_ADDRESS | the email address to be used in GPG key generation | `ci@clevyr.com` |
| GPG_PASSWORD  | the GPG key password                               | `password123`   |
