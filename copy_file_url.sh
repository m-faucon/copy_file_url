#!/usr/bin/env bash

file=$1
line=$2
open_in_browser=$3

pushd $(dirname "$file") 1> /dev/null

root=$(git rev-parse --show-toplevel)

remote_url=$(git remote get-url $(git remote | head -n 1))

branch=$(git branch --show-current)

popd 1> /dev/null


relative_file=$(realpath --relative-to "$root" "$file")


if [[ "$remote_url" == git@* ]]; then
    url_type="ssh"
elif [[ "$remote_url" == https://* ]]; then
    url_type="https"
else
    echo "unrecognized remote uri scheme"
    exit 1
fi

if [[ "$url_type" = "ssh" ]]; then
    website_name=$(echo "$remote_url" | cut -d '@' -f 2 | cut -d ':' -f 1)
else
    website_name=$(echo "$remote_url" | cut -d '/' -f 3)
fi

github_ssh_to_full_url () {
    full_url="$(echo "$remote_url" | sed \
        -e 's|git@|https://|' \
        -e 's|:|/|2' \
        -e 's|\.git||')/blob/${branch}/${relative_file}/#L${line}"
}

github_https_to_full_url () {
    full_url="$(echo "$remote_url" | sed \
        -e 's|\.git||')/blob/${branch}/${relative_file}/#L${line}"
}


gitlab_full_url () {
    full_url="$(echo "$remote_url" | sed \
        -e 's|git@|https://|' \
        -e 's|:|/|2' \
        -e 's|\.git||')/-/tree/${branch}/${relative_file}/#L${line}"
}


gitlab_https_to_full_url () {
    full_url="$(echo "$remote_url" | sed \
        -e 's|\.git||')/-/tree/${branch}/${relative_file}/#L${line}"
}

source_hut_full_url () {
    full_url="$(echo "$remote_url" | sed \
        -e 's|git@|https://|' \
        -e 's|:|/|2' \
        -e 's|\.git||')/tree/${branch}/item/${relative_file}/#L${line}"
}

source_hut_https_to_full_url () {
    full_url="${remote_url}/tree/${branch}/item/${relative_file}/#L${line}"
}


case "${website_name},${url_type}" in
    "github.com,ssh")
        github_ssh_to_full_url
        ;;
    "github.com,https")
        github_https_to_full_url
        ;;
    "gitlab.com,ssh")
        gitlab_ssh_to_full_url
        ;;
    "gitlab.com,https")
        gitlab_https_to_full_url
        ;;
    "git.sr.ht,ssh")
        source_hut_ssh_to_full_url
        ;;
    "git.sr.ht,https")
        source_hut_https_to_full_url
        ;;
    *)
        echo "no implementation for this remote"
        exit 1
esac

clip_cmd=$(which pbcopy) # macOS

if [[ -z "$clip_cmd" ]]; then
    clip_cmd=$(which clip.exe) # WSL
fi

if [[ -z "$clip_cmd" ]]; then
    clip_cmd=$(echo "$(which xclip) -selection clip-board" | grep xclip) # X11
fi

if [[ -z "$clip_cmd" ]]; then
    clip_cmd=$(which wl-copy) # Wayland
fi

if [[ -z "$clip_cmd" ]]; then
    echo "could not find a suitable clip command"
    exit 1
fi

echo "$full_url" | $clip_cmd

echo "copied to clipboard : ${full_url}"


exit 0
