#!/bin/bash

# Check for the --silent flag (optional to suppress output)
SUPPRESS_OUTPUT=false
if [ "$1" == "--silent" ]; then
    SUPPRESS_OUTPUT=true
fi

# Function to print messages
log_message() {
    if [ "$SUPPRESS_OUTPUT" == "false" ]; then
        echo "$1"
    fi
}

# Check if CPU supports nested virtualization
log_message "Checking if your CPU supports nested virtualization..."
CPU_SUPPORTS_NESTED=$(grep -E -c '(vmx|svm)' /proc/cpuinfo)
if [ "$CPU_SUPPORTS_NESTED" -eq 0 ]; then
    log_message "Your CPU does not support virtualization. Aborting installation."
    exit 1
else
    log_message "CPU supports virtualization. Continuing..."
fi

# Update repositories
log_message "Updating repositories..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf update -y > /dev/null 2>&1
else
    sudo dnf update -y
fi

# Upgrade packages
log_message "Upgrading repositories..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf upgrade -y > /dev/null 2>&1
else
    sudo dnf upgrade -y
fi

# Enable the Free repository
log_message "Enabling the Fedora Free repository..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm > /dev/null 2>&1
else
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi

# Enable the Nonfree repository
log_message "Enabling the Fedora Nonfree repository..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm > /dev/null 2>&1
else
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# Update repositories again after adding RPMFusion repositories
log_message "Updating repositories again..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf update -y > /dev/null 2>&1
else
    sudo dnf update -y
fi

# Install GNS3 dependencies
log_message "Installing dependencies for GNS3..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf install -y qemu-kvm libvirt libvirt-daemon libvirt-client bridge-utils virt-manager dynamips ubridge wireshark > /dev/null 2>&1
else
    sudo dnf install -y qemu-kvm libvirt libvirt-daemon libvirt-client bridge-utils virt-manager dynamips ubridge wireshark
fi

# Start and enable libvirtd on startup
log_message "Starting and enabling libvirtd service..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo systemctl enable --now libvirtd > /dev/null 2>&1
else
    sudo systemctl enable --now libvirtd
fi

# Install GNS3 GUI and Server
log_message "Installing GNS3 GUI and Server..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo dnf install -y gns3-gui gns3-server > /dev/null 2>&1
else
    sudo dnf install -y gns3-gui gns3-server
fi

# Add user to necessary groups
log_message "Adding user to necessary groups..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo usermod -aG ubridge,libvirt,kvm,wireshark $(whoami) > /dev/null 2>&1
else
    sudo usermod -aG ubridge,libvirt,kvm,wireshark $(whoami)
fi

log_message "Configuring network interfaces..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo systemctl start libvirtd > /dev/null 2>&1
    sudo systemctl enable libvirtd > /dev/null 2>&1
    sudo systemctl start virtlogd > /dev/null 2>&1
    sudo systemctl enable virtlogd > /dev/null 2>&1
    sudo virsh net-start default > /dev/null 2>&1
    sudo virsh net-autostart default > /dev/null 2>&1
else
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd
    sudo systemctl start virtlogd
    sudo systemctl enable virtlogd
    sudo virsh net-start default
    sudo virsh net-autostart default
fi

# Fixing VPCS bug on Fedora 41
log_message "Moving VPCS to /usr/local/bin..."
if [ "$SUPPRESS_OUTPUT" == "true" ]; then
    sudo cp ./vpcs /usr/local/bin/ > /dev/null 2>&1
else
    sudo cp ./vpcs /usr/local/bin/
fi

sleep 5
# Final message to reboot
log_message "GNS3 installation is complete. Rebooting your system for the changes to take effect."
sleep 2
log_message "Rebooting now..."
sleep 10
sudo reboot
