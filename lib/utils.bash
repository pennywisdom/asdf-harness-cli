#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/harness/harness-cli"
TOOL_NAME="harness-cli"
TOOL_TEST="harness --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if harness-cli has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	local arch="$(get_arch)"

	case $(uname | tr '[:upper:]' '[:lower:]') in
	linux*)
		local platform="linux-${arch}"
		local ext="tar.gz"
		;;
	darwin*)
		local platform="darwin-${arch}"
		local ext="tar.gz"
		;;
	windows*)
		local platform="windows-${arch}"
		local ext="zip"
		;;
	*)
		local platform=notset
		local ext=notset
		;;
	esac

	# TODO: Adapt the release URL convention for harness-cli
	# url="$GH_REPO/archive/v${version}.tar.gz"
	# https://github.com/harness/harness-cli/releases/download/v0.0.25-Preview/harness-v0.0.25-Preview-linux-arm64.tar.gz
	url="$GH_REPO/releases/download/v${version}/harness-v${version}-${platform}.${ext}"
	# https://github.com/harness/harness-cli/releases/download/v0.0.25-Preview/harness-v0.0.25-Preview-linux-amd64.tar.gz
	echo "* Downloading $TOOL_NAME release $version from $url to $filename ..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	echo "installing version ${version} to ${install_path} from ${ASDF_DOWNLOAD_PATH}..."

	test -d "$ASDF_DOWNLOAD_PATH" || fail "Expected $ASDF_DOWNLOAD_PATH to be a directory."

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert harness-cli executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

get_arch() {
	local machine_hardware_name="$(uname -m)"

	case "$machine_hardware_name" in
	'x86_64') local arch="amd64" ;;
	'powerpc64le' | 'ppc64le') local arch="ppc64le" ;;
	'aarch64') local arch="arm64" ;;
	'armv7l') local arch="arm" ;;
	*) local arch="$machine_hardware_name" ;;
	esac

	echo "${arch}"
}
