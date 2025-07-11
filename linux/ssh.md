# SSHD (SSH Daemon) Service Documentation

## 📘 Overview

`sshd` (Secure Shell Daemon) is the background service that allows secure remote login and command execution over an encrypted connection. It is part of the OpenSSH suite, which provides a secure channel over an unsecured network.

---

## 📂 File Locations

| File/Directory                           | Description                               |
| ---------------------------------------- | ----------------------------------------- |
| `/etc/ssh/sshd_config`                   | Main configuration file for `sshd`        |
| `/etc/ssh/ssh_config`                    | Client-side SSH config                    |
| `/var/log/auth.log` or `/var/log/secure` | Log files for SSH authentication attempts |
| `/etc/hosts.allow` / `/etc/hosts.deny`   | TCP wrappers for access control           |
| `/etc/passwd`, `/etc/shadow`             | User authentication files                 |

---

## ⚙️ Service Control

### Systemd Commands (Linux)

```bash
sudo systemctl enable sshd 
sudo systemctl start sshd        # Start the service
sudo systemctl stop sshd         # Stop the service
sudo systemctl restart sshd      # Restart the service
sudo systemctl reload sshd       # Reload config without dropping connections
sudo systemctl status sshd       # Check status
```

### configuration
```Port 22                      # Default SSH port (can be changed)
PermitRootLogin no           # Disable root login
PasswordAuthentication no    # Disable password login (use keys instead)
PubkeyAuthentication yes     # Enable public key authentication
MaxAuthTries 3               # Limit number of authentication attempts
LoginGraceTime 30            # Seconds before login times out
AllowUsers user1 user2       # Only allow specific users
PermitEmptyPasswords no      # Disallow login with empty passwords
LogLevel VERBOSE             # Log user key fingerprint, etc.
```