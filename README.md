<h1 align="center"><a href="https://linkpanel.atsi.cloud/">LinkPanel</a></h1>

## **Welcome!**

LinkPanel is designed to provide administrators an easy to use web and command line interface, enabling them to quickly deploy and manage web domains, mail accounts, DNS zones, and databases from one central dashboard without the hassle of manually deploying and configuring individual components or services.

## Features and Services

- Apache2 and NGINX with PHP-FPM
- Multiple PHP versions (5.6 - 8.3, 8.2 as default)
- DNS Server (Bind) with clustering capabilities
- POP/IMAP/SMTP mail services with Anti-Virus, Anti-Spam, and Webmail (ClamAV, SpamAssassin, Sieve, Roundcube)
- MariaDB/MySQL and/or PostgreSQL databases
- Let's Encrypt SSL support with wildcard certificates
- Firewall with brute-force attack detection and IP lists (iptables, fail2ban, and ipset).

## Supported platforms and operating systems

- **Debian:** 12, 11, or 10
- **Ubuntu:** 22.04 LTS, 20.04 LTS

**NOTES:**

- LinkPanel does not support 32 bit operating systems!
- LinkPanel in combination with OpenVZ 7 or lower might have issues with DNS and/or firewall. If you use a Virtual Private Server we strongly advice you to use something based on KVM or LXC!

## Installing LinkPanel Control Panel

- **NOTE:** You must install LinkPanel on top of a fresh operating system installation to ensure proper functionality.

While we have taken every effort to make the installation process and the control panel interface as friendly as possible (even for new users), it is assumed that you will have some prior knowledge and understanding in the basics how to set up a Linux server before continuing.

### Step 1: Log in

To start the installation, you will need to be logged in as **root** or a user with super-user privileges. You can perform the installation either directly from the command line console or remotely via SSH:

```bash
ssh root@your.server
```

### Step 2: Download

Download the installation script for the latest release:

```bash
wget https://raw.githubusercontent.com/ATSiCorp/LinkPanel-V3/release/install/linkpnl-install.sh
```

If the download fails due to an SSL validation error, please be sure you've installed the ca-certificate package on your system - you can do this with the following command:

```bash
apt-get update && apt-get install ca-certificates
```

### Step 3: Run

To begin the installation process, simply run the script and follow the on-screen prompts:

```bash
bash linkpnl-install.sh
```

You will receive a welcome email at the address specified during installation (if applicable) and on-screen instructions after the installation is completed to log in and access your server.

### Custom installation

You may specify a number of various flags during installation to only install the features in which you need. To view a list of available options, run:

```bash
bash linkpnl-install.sh -h
```

Alternatively, You can use <https://linkpanel.atsi.cloud/install.html> which allows you to easily generate the installation command via GUI.

## How to upgrade an existing installation

Automatic Updates are enabled by default on new installations of LinkPanel and can be managed from **Server Settings > Updates**. To manually check for and install available updates, use the apt package manager:

```bash
apt-get update
apt-get upgrade
```