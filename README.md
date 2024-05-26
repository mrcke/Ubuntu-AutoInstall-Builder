AutoInstall Builder for Ubuntu 

AutoInstallBuilder is a Bash script designed to automate the process of creating a custom Ubuntu 22.04.2 Live Server ISO. This custom ISO includes pre-configured user-data for Ubuntu's auto-install feature, allowing for a hands-off installation process. It's ideal for rapidly deploying Ubuntu servers with predefined settings. 


Features
    Download ISO: Automatically fetches the Ubuntu 22.04.2 Live Server ISO.
    Set User-Data: Easily configure hostname, username, and password for the auto-installation process.
    Custom ISO Creation: Extracts, modifies, and repackages the ISO to include custom user-data for automated installations.
    NoCloud Data Source: Utilizes the NoCloud data source for cloud-init, allowing the ISO to use user-data and meta-data for auto-installation.
    GRUB Configuration: Updates the GRUB menu to include an auto-installation option.

Prerequisites
    A system running Ubuntu or a compatible distribution.
    Internet connection for downloading the original Ubuntu ISO.
    whois package for generating hashed passwords.
    xorriso for manipulating ISO images.

Getting Started
    Download or clone this repository to your local machine.
    Navigate to the directory containing autoinstall.sh.
    
    Make the script executable:
    chmod +x autoinstall.sh

    Run the script with root privileges:
    sudo ./autoinstall.sh



Follow the on-screen prompts to complete the process.
The script operates through a menu-driven interface, offering options to:

    1)Download the Ubuntu ISO.
    2)Set user-data (hostname, username, password).
    3)View the configured user-data.
    4)Extract the ISO contents.
    5)Update the GRUB configuration for auto-installation.
    6)Recreate the ISO with your custom settings.
    7)Exit the script.


Customization
You can edit the AutoInstallBuilder.sh script to modify default paths, the download link for the Ubuntu ISO, or to customize the GRUB menu entries according to your requirements.
Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues to suggest improvements or report bugs.
