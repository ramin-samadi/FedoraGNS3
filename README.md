# FedoraGNS3

FedoraGNS3 is a streamlined solution to simplify the setup and installation of GNS3 on Fedora-based systems. This repository provides a single script to configure dependencies, virtualization, and networking components required for GNS3.

## Features

- **Automatic Dependency Installation**: Installs all necessary tools like `qemu-kvm`, `libvirt`, and `gns3-gui`.
- **Virtualization Configuration**: Enables and configures essential virtualization services.
- **Network Setup**: Configures bridge utilities and networking for seamless GNS3 operation.
- **Silent Mode**: Option to suppress output for a clean installation experience.

## Repository Layout

```
FedoraGNS3
    ├── bin
    │   └── vpcs # VPCS binary for GNS3
    ├── LICENSE # MIT License file
    ├── README.md # Project documentation
    └── scripts 
        └── install.sh # Installation script for GNS3 
```

## Prerequisites

Ensure you have the following before proceeding:

1. **Fedora OS** (tested on Fedora 41 but should work on similar versions).
2. **Administrative Privileges** (sudo access).

## Installation

1. **Clone the Repository**  
   Download the repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/FedoraGNS3.git
   cd FedoraGNS3
   ```

2. **Run the Installation Script**  
   Execute the script to install and configure GNS3:
   ```bash
   ./scripts/install.sh
   ```
   - Use the `--silent` flag for a quiet installation:
     ```bash
     ./scripts/install.sh --silent
     ```

3. **Reboot Your System**  
   A reboot is required to apply changes:
   ```bash
   sudo reboot
   ```

## Usage

Once installed:

- Launch the **GNS3 GUI** from your application menu or by typing `gns3` in the terminal.
- Ensure your user is added to the necessary groups (e.g., `libvirt`, `kvm`, `ubridge`, `wireshark`).

## Troubleshooting

- If GNS3 fails to start or virtualization is not working, verify:
  - The `libvirtd` service is running:
    ```bash
    systemctl status libvirtd
    ```
  - Your CPU supports virtualization:
    ```bash
    grep -E '(vmx|svm)' /proc/cpuinfo
    ```
- For additional help, consult the [GNS3 documentation](https://docs.gns3.com/).

## Contributing

We welcome contributions! Here's how you can help:

1. Fork this repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add a detailed description of your changes"
   ```
4. Push your branch:
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to the Fedora community and GNS3 developers for creating an amazing networking simulation platform.
