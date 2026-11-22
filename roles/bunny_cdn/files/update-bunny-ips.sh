#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

out="/etc/nginx/conf.d/bunny_ips.conf"
tmp=$(mktemp)
trap 'rm --force "${tmp}"' EXIT

url_v4="https://bunnycdn.com/api/system/edgeserverlist/plain"
url_v6="https://bunnycdn.com/api/system/edgeserverlist/ipv6/plain"

ips=$(curl --fail --silent "${url_v4}" "${url_v6}" | tr --delete '\r')

if [[ -z "${ips}" ]]; then
  echo "Error: Failed to fetch Bunny CDN edge server IPs" >&2
  exit 1
fi

{
  cat << 'EOF'
real_ip_header X-Forwarded-For;
real_ip_recursive on;

EOF
  sed 's/^/set_real_ip_from /; s/$/;/' <<< "${ips}"
  echo ""
  echo 'geo $realip_remote_addr $is_bunny_cdn {'
  echo "    default 0;"
  sed 's/^/    /; s/$/ 1;/' <<< "${ips}"
  echo "}"
} > "${tmp}"

mv "${tmp}" "${out}"
chmod 0644 "${out}"

if nginx -t >/dev/null 2>&1; then
  systemctl is-active --quiet nginx && systemctl reload nginx || true
fi
