#!/bin/bash
# Bootstrap script to install and call Ansible.
# This must be run as root.
# Exit on error. Append "|| true" if you expect an error.
set -o errexit 
# Exit on error inside any function or subshells.  
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o nounset 
# Catch the error in case cmd1 fails (but cmd2 succeeds) in  `cmd1 | cmd2 `.
set -o pipefail
# Turn on traces, useful while debugging but commentend out by default
# set -o xtrace

current_uid=$(id -u)
os_release_file="/etc/os-release"
oldest_os_version="37"

echo "Sanity checks..."

if [ "${current_uid}" != "0" ]; then
  echo "ERROR: you need admin rights to run this script."
  echo "exiting..."
  exit 1
fi

if [ -f "${os_release_file}" ]; then
  # shellcheck source=/etc/os-release
  . "${os_release_file}"
else
  echo "ERROR: cannot check OS version."
  echo "exiting..."
  exit 1
fi

if [ "${ID}" != "fedora" ]; then
  echo "ERROR: Wrong distro."
  echo "exiting..."
  exit 1
fi

if [ "${VERSION_ID}" \< "${oldest_os_version}" ]; then
  echo "ERROR: Your Fedora version is too old."
  echo "You need at least Fedora version ${oldest_os_version}"
  echo "exiting..."
  exit 1
fi

echo "Alright, everything checks out."

echo "Installing software dependencies..."
dnf --quiet --assumeyes clean all
set +e
is_ansible_installed="$(rpm -q ansible-collection-ansible-posix)"
if [ "${is_ansible_installed}" != "0" ]; then
	dnf --quiet --assumeyes install ansible-core \
		ansible-collection-community-general \
		ansible-collection-ansible-posix
fi
set -o errexit 
echo "Done !"

echo "Executing the playbook..."
ansible-playbook ./ansible/playbooks/bootstrap_workstation.yml
echo "Done !"
 
# vim:ts=2:sw=2
