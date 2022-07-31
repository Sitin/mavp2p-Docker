#!/usr/bin/env sh

set -e

###############################################################################
# Config
###############################################################################

repo_url=https://github.com/Sitin/mavp2p-Docker.git
mavp2p_repo_url=https://github.com/aler9/mavp2p.git

###############################################################################
# Getting the latest tags
###############################################################################

latest_tag=$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${repo_url}" \
            | tail --lines=1 \
            | awk -F/ '{ print $3 }')

latest_mavp2p_tag=$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${mavp2p_repo_url}" \
                    | tail --lines=1 \
                    | awk -F/ '{ print $3 }')

echo "Latest tag: '${latest_tag}'. Latest mavp2p tag: '${latest_mavp2p_tag}'."

###############################################################################
# Set latest mavp2p tag if not set
###############################################################################

if [ "${latest_tag}" = "${latest_mavp2p_tag}" ]; then
  echo "Latest tags are in sync, nothing to update."
else
  echo "Setting the latest git tag to '${latest_mavp2p_tag}'."
  git tag "${latest_mavp2p_tag}"
fi
