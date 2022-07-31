#!/usr/bin/env sh

set -e

platform="${TARGETPLATFORM:-UNKNOWN}"
_tag="${MAVP2P_TAG:-vUNKNOWN}"
# shellcheck disable=SC2039
version="${_tag:1}"
destination="${1:-${PWD}}"

if [ "${platform}" = "UNKNOWN" ]; then echo "ERROR: Target platform is not set!"; exit 1; fi
if [ "${version}" = "UNKNOWN" ]; then echo "ERROR: Target version is not set!"; exit 1; fi

# Naming conventions match v0.6.5 (https://github.com/aler9/mavp2p/releases)
case "${platform}" in
  linux/arm64)
    dist_platform=linux_arm64
    ;;
   linux/amd64)
    dist_platform=linux_amd64
    ;;
   linux/arm/v6)
    dist_platform=linux_arm6
    ;;
   linux/arm/v7)
    dist_platform=linux_arm7
    ;;
  *)
    echo "ERROR: Unsupported platform: ${platform}"
    exit 1
esac

load_url="https://github.com/aler9/mavp2p/releases/download/v${version}/mavp2p_v${version}_${dist_platform}.tar.gz"

echo "Loading mavp2p distribution from ${load_url}"
curl -L "https://github.com/aler9/mavp2p/releases/download/v${version}/mavp2p_v${version}_${dist_platform}.tar.gz" | tar -xz -C "${destination}"
chmod +x "${destination}/mavp2p"
