#!/bin/bash

# Constants
VPCS_BINARY="./bin/vpcs"
VPCS_INSTALL_PATH="/usr/local/bin/vpcs"

# Check for the --silent flag (optional to suppress output)
SUPPRESS_OUTPUT=false
if [ "$1" == "--silent" ]; then
    SUPPRESS_OUTPUT=true
fi

# Function to print messages
log_message() {
    if [ "$SUPPRESS_OUTPUT" == "false" ]; then
        echo -e "$1"
    fi
}

# Check if CPU supports nested virtualization
log_message "Checking if your CPU supports nested virtualization..."
if ! grep -E -q '(vmx|svm)' /proc/cpuinfo; then
    log_message "\033[31mError: Your CPU does not support virtualization. Aborting installation.\033[0m"
    exit 1
else
    log_message "\033[32mSuccess: CPU supports virtualization. Continuing...\033[0m"
fi

# Function to run commands with optional suppression
run_command() {
    if [ "$SUPPRESS_OUTPUT" == "true" ]; then
        "$@" > /dev/null 2>&1
    else
        "$@"
    fi
}

# Update and upgrade repositories
log_message "Updating and upgrading repositories..."
run_command sudo dnf update -y
run_command sudo dnf upgrade -y

# Enable RPM Fusion repositories
log_message "Enabling RPM Fusion Free and Nonfree repositories..."
run_command sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
run_command sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update repositories after enabling RPM Fusion
log_message "Updating repositories again after enabling RPM Fusion..."
run_command sudo dnf update -y

# Install GNS3 dependencies
log_message "Installing GNS3 dependencies..."
run_command sudo dnf install -y qemu-kvm libvirt libvirt-daemon libvirt-client bridge-utils virt-manager dynamips ubridge wireshark gns3-gui gns3-server

# Enable and start libvirtd service
log_message "Starting and enabling libvirtd service..."
run_command sudo systemctl enable --now libvirtd
run_command sudo systemctl enable --now virtlogd

# Add the current user to necessary groups
log_message "Adding user to necessary groups (ubridge, libvirt, kvm, wireshark)..."
run_command sudo usermod -aG ubridge,libvirt,kvm,wireshark "$(whoami)"

# Configure libvirt default network
log_message "Configuring libvirt default network..."
run_command sudo virsh net-start default
run_command sudo virsh net-autostart default

# Install VPCS binary
log_message "Installing VPCS binary to $VPCS_INSTALL_PATH..."
if [ -f "$VPCS_BINARY" ]; then
    run_command sudo cp "$VPCS_BINARY" "$VPCS_INSTALL_PATH"
    log_message "\033[32mSuccess: VPCS binary installed to $VPCS_INSTALL_PATH.\033[0m"
else
    log_message "\033[31mError: VPCS binary not found at $VPCS_BINARY. Skipping...\033[0m"
fi

# Final message and system reboot
log_message "\033[32mGNS3 installation is complete! Rebooting your system to apply changes...\033[0m"
sleep 5
run_command sudo reboot
